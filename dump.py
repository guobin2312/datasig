import gdb
import sys

global NAME

ERROR='@@@'
SHIFT='    '
TAB='\t'

def get_basic_type(type_):
    """Return the "basic" type of a type.

    Arguments:
        type_: The type to reduce to its basic type.

    Returns:
        type_ with const/volatile is stripped away,
        and typedefs/references converted to the underlying type.
    """

    while (type_.code == gdb.TYPE_CODE_REF or
           type_.code == gdb.TYPE_CODE_TYPEDEF):
        if type_.code == gdb.TYPE_CODE_REF:
            type_ = type_.target()
        else:
            type_ = type_.strip_typedefs()
    return type_.unqualified()

def print_type_recursively(text_, type_, field_, pref_, known_):
    type_ = get_basic_type(type_)
    code_ = type_.code
    name_ = getattr(type_, 'name', '')
    tag_  = getattr(type_, 'tag', '')
    size_ = getattr(type_, 'sizeof', '')
    if field_ is None:
        print(("%s"+TAB+"/* size=%u */") % (text_, size_))
    else:
        bitpos_ = getattr(field_, 'bitpos', 0)
        bitsize_ = getattr(field_, 'bitsize', 0)
        if bitsize_ == 0:
            print(("%s"+TAB+"/* size=%u bitpos=%u */") % (text_, size_, bitpos_))
        else:
            print(("%s"+TAB+"/* size=%u bitpos=%u bitsize=%u */") % (text_, size_, bitpos_, bitsize_))
    if text_ in known_:
        return
    if code_ == gdb.TYPE_CODE_STRUCT and text_ == 'struct {...}':   # anonymous struct
        pass
    elif code_ == gdb.TYPE_CODE_UNION and text_ == 'union {...}':   # anonymous union
        pass
    else:
        known_[text_] = True

    if code_ == gdb.TYPE_CODE_STRUCT or code_ == gdb.TYPE_CODE_UNION:
        fields_ = type_.fields()
        if fields_:
            print("%s{" % pref_)
            for field_ in fields_:
                name_ = getattr(field_, 'name', '')
                type_ = getattr(field_, 'type', None)
                #print("%s%s%s =" % (pref_, SHIFT, name_)),
                sys.stdout.write("%s%s%s =" % (pref_, SHIFT, name_))
                print_type_recursively(str(type_), type_, field_, pref_ + SHIFT, known_);
            print("%s}" % pref_)
    elif code_ == gdb.TYPE_CODE_ARRAY:
        type_ = type_.target()
        if type_:
            print("%s[" % pref_)
            sys.stdout.write("%s" % (pref_ + SHIFT))
            print_type_recursively(str(type_), type_, None, pref_ + SHIFT, known_);
            print("%s]" % pref_)


try:
    NAME
except NameError:
    NAME = None
if NAME is None:
    NAME = 'datasig_all_t'

try:
    all = gdb.lookup_type(NAME)
    print_type_recursively(NAME, all, None, '', {})
except:
    print('%s: no such type %s' % (ERROR, NAME))
    #raise
