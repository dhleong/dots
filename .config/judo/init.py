
# NOTE: these are imported on-demand, below; that saves a few hundred ms if the
# modules aren't actually used

# import os
# import json
# from datetime import date

# pylint: disable=unused-import
try:
    from judo import createMap, createUserMode, enterMode, send
    from judo import logToFile
    from judo import normal
    from judo import inoremap, nnoremap
    from judo import judo
    from judo import config, event, expandpath
    from judo import vsplit
    from judo import recolor
except ImportError, e:
    pass


#
# Settings
#

config('clipboard', 'unnamed')
config('inputlines', 4)
config('mouse', True)

#
# Colors
#

colors = {
    'normal':     '\033[0m',
    'bold':       '\033[1m',
    'underline':  '\033[4m',
    'blink':      '\033[5m',
    'reverse':    '\033[7m',
    'invisible':  '\033[8m',

    'black':      '\033[30m',
    'blue':       '\033[34m',
    'green':      '\033[32m',
    'cyan':       '\033[36m',
    'red':        '\033[31m',
    'purple':     '\033[35m',
    'brown':      '\033[33m',
    'gray':       '\033[37m',
    'yellow':     '\033[33m',
    'white':      '\033[37m', }

#
# Functions
#

def askAndSend(prompt, cmd, *extraCmds):
    target = input(prompt)
    if target:
        send(cmd + ' ' + target)
        for ecmd in extraCmds:
            send(ecmd + ' ' + target)


def askAndSendAction(*args, **kwargs):
    def action():
        askAndSend(*args, **kwargs)
    return action


def gmap(mapKeys, toSend):
    def fn(): send(toSend)

    nnoremap(mapKeys, fn)
    createMap('nav', mapKeys, fn)


def logToPickedFile(dirName = None):
    logToFile(pickLogFile(), 'append html')


def mapToPickedFile(dirName = None):
    config('map:automagic', True)
    config('map:autorender', True)

    mapFile = pickMapFile()
    if os.path.exists(mapFile):
        judo.mapper.load(mapFile)
        print "Loaded map %s" % mapFile
    else:
        judo.mapper.createEmpty()
        judo.mapper.saveAs(mapFile)
        print "Created empty map %s" % mapFile

    primaryWindow = judo.current.window
    if judo.mapper.window.id == primaryWindow.id:
        judo.mapper.window = vsplit(20)
        judo.current.window = primaryWindow

    def persistMap():
        if judo.mapper.current is not None:
            judo.mapper.save()
            print "Saved map"
        else:
            print "No map to save"

    event("DISCONNECTED", persistMap)


def pickLogFile():
    import os
    from datetime import date

    scriptDir = os.path.dirname(findScriptDir())

    dateStr = date.today().isoformat()
    path = '%s/logs/%s.html' % (scriptDir, dateStr)

    print "Logging to %s" % path

    dirPath = os.path.dirname(path)
    if not os.path.isdir(dirPath):
        os.makedirs(dirPath)
    return path


def pickMapFile():
    import os

    scriptDir = os.path.dirname(findScriptDir())
    scriptDirName = os.path.basename(scriptDir)

    path = '%s/%s.map' % (scriptDir, scriptDirName)
    print "Mapping to %s" % path

    dirPath = os.path.dirname(path)
    if not os.path.isdir(dirPath):
        os.makedirs(dirPath)
    return path

def findScriptDir():
    scriptFile = expandpath("<sfile>")
    if scriptFile is not None:
        return scriptFile

    return expandpath("<lastread>")

def sendMsdp(command, arg):
    IAC = "\xff"
    SB = "\xfa"
    SE = "\xf0"
    MSDP = "\x45"
    MSDP_VAR = "\x01"
    MSDP_VAL = "\x02"
    send(IAC + SB + MSDP + MSDP_VAR + command + MSDP_VAL + arg + IAC + SE)


def sendGmcp(command, arg=None):
    import json

    IAC = "\xff"
    SB = "\xfa"
    SE = "\xf0"
    GMCP = "\xc9"
    message = command
    if arg is not None:
        arg = " " + json.dumps(arg)
        message = command + arg
    send(IAC + SB + GMCP + message + IAC + SE)

#
# navigation convenience
#
dirs = {'j': 's',
        'k': 'n',
        'h': 'w',
        'l': 'e',
        'u': 'nw',
        'o': 'ne',
        'n': 'sw',
        ',': 'se',
        's': 'down',
        'w': 'up'}

createUserMode('nav')
nnoremap('q', lambda: enterMode('nav'))
nnoremap('`', lambda: enterMode('nav'))
inoremap('`', lambda: enterMode('nav'))
createMap('nav', '<ctrl-r>', '<esc><ctrl-s>')
createMap('nav', 'q', '<esc>')
createMap('nav', 'i', lambda: enterMode('insert'))
createMap('nav', ':', lambda: enterMode('cmd'))
createMap('nav', 'e', askAndSendAction('Enter what? ', 'enter'))

createMap('nav', '<ctrl-s>', askAndSendAction('say ', 'say'))
createMap('nav', '<ctrl-l>', askAndSendAction('look ', 'look'))

navConfig = {
    'openDoorCommand': 'open'
}

def sendOpenDoor(direction):
    send(navConfig['openDoorCommand'] + ' ' + direction)

persistFromNormal = ['<ctrl-b>', '<ctrl-f>']
for keys in persistFromNormal:
    createMap('nav', keys, lambda k=keys: normal(k))

for key, navDir in dirs.iteritems():
    ctrlKey = '<ctrl-%s>' % key

    def sendDir(d=navDir): send(d)
    inoremap(ctrlKey, sendDir)
    # nnoremap(ctrlKey, sendDir)
    createMap('nav', key, sendDir)
    if key == ',':
        createMap('nav', '<', lambda d=navDir: sendOpenDoor(d))
    else:
        createMap('nav', key.upper(), lambda d=navDir: sendOpenDoor(d))

def setOpenDoorCommand(newCommand):
    navConfig['openDoorCommand'] = newCommand

#
# General mappings
#

gmap('gl', 'look')
gmap('gi', 'inventory')
gmap('gs', 'save')

# "reload init"
nnoremap('<space>ri', lambda: normal(':load(MYJUDORC)<cr>'))

# muscle memory from terminal: use <ctrl-r> to search history instead of Judo's
# default <ctrl-s>. We don't support Vim's notion of U (and I don't need to
# redo an undo very often) so just map redo there. It sort of makes sense
nnoremap('<ctrl-r>', '<ctrl-s>')
nnoremap('U', '<ctrl-r>')

# terminal sends <Up> and <Down> for the scroll wheel; I don't use it anyway
# (except maybe in cmd mode) so let's just map them to scrolling
nnoremap('<up>', '<ctrl-y>')
nnoremap('<down>', '<ctrl-e>')

#
# Color theme
#

# strip unnecessary black backgrounds (my terminal bg is already dark)
recolor('bg', 'black', 'default')
