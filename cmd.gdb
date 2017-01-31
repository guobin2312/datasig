# set print pretty
file datasig
# p/z datasig_var
#python execfile('dump.py', { 'NAME' : 'datasig_all_t' })
python exec(compile(open('dump.py').read(), 'dump.py', 'exec'), { 'NAME' : 'datasig_all_t' })
quit
