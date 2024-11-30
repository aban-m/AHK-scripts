from configparser import ConfigParser

def make_latex(hs, operator):
    return f'::\\#{hs}::\n\tSendRaw, {operator}\n\tReturn\n'

config = ConfigParser()
config.read('map.ini')

with open('latex.ahk', 'w') as fp:
    for k, v in config['latex'].items():
        fp.write(make_latex(k, v))
        fp.flush()
