#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import os
from cookiecutter.main import cookiecutter
from mfutil import BashWrapperOrRaise
from mfplugin.utils import validate_plugin_name, BadPluginName
import shutil
import glob
import sys
from bash import bash


MFMODULE = os.environ['MFMODULE']
MFMODULE_LOWERCASE = os.environ['MFMODULE_LOWERCASE']
MFMODULE_HOME = os.environ['MFMODULE_HOME']
PLUGIN_TEMPLATES_PATH = "%s/share/templates/plugins/" % MFMODULE_HOME


parser = argparse.ArgumentParser()
subparsers = parser.add_subparsers(dest='subcommand',
                                   help='sub-command help')
parser_list = subparsers.add_parser('list',
                                    help="List of available templates \
                                    to create a plugin")
parser_create = subparsers.add_parser('create',
                                      help='Create a plugin with a \
                                      template')
parser_create.add_argument("--template",
                           required=False,
                           default="default",
                           help="the template to use for create the \
                           plugin")
parser_create.add_argument("--no-input", action="store_true",
                           help="pick default values and don't prompt "
                           "anything")
parser_create.add_argument("--make", action="store_true",
                           help="build the plugin")
parser_create.add_argument("--install", action="store_true",
                           help="install the plugin file "
                           "(--make is mandatatory)")
parser_create.add_argument("--delete", action="store_true",
                           help="delete the plugin directory and just "
                           "keep the plugin file (--make is mandatatory)")
parser_create.add_argument("plugin", help="the name of the plugin to \
                           create")
args = parser.parse_args()

if args.subcommand not in ("list", "create"):
    parser.print_help()
    parser.exit(status=0)

if args.subcommand == 'list':
    print("List of available plugin templates:")
    for plugin in os.listdir(PLUGIN_TEMPLATES_PATH):
        if plugin.startswith('_'):
            continue
        print('     * %s' % (plugin))
    parser.exit(status=0)

template_path = "%s/%s" % (PLUGIN_TEMPLATES_PATH, args.template)
if not os.path.isdir(template_path):
    print("ERROR : this template [%s] does not exist" % args.template)
    parser.exit(1)

if os.path.isdir(args.plugin):
    print("ERROR : the subdirectory %s already exists in %s" %
          (args.plugin, os.getcwd()))
    parser.exit(1)

try:
    validate_plugin_name(args.plugin)
except BadPluginName as e:
    print("ERROR: the plugin name: %s is not valid" % args.plugin)
    print("Validation error: %s" % e)
    parser.exit(1)

extra_context = {"name": args.plugin,
                 "MFMODULE_VERSION": os.environ["MFMODULE_VERSION"]}
res = cookiecutter(template_path, extra_context=extra_context,
                   no_input=args.no_input,
                   search_paths=[PLUGIN_TEMPLATES_PATH])

if not os.path.isdir(res):
    print("ERROR : cookiecutter result is not a valid directory")
    parser.exit(1)

BashWrapperOrRaise("cd %s && remove_empty.sh" % args.plugin)

BashWrapperOrRaise("cd %s && bootstrap_plugin.post" % args.plugin)

if args.make:
    print("Make plugin on directory %s" % args.plugin)
    os.chdir("%s" % args.plugin)
    b = bash("make release")
    print("%s" % b.stdout)

    if b.code == 0:
        if args.install:
            for fic in glob.glob("*.plugin"):
                print("Installing plugin %s" % fic)
                b = bash("plugins.install %s" % fic)
                print("%s" % b.stdout)
                if b.code != 0:
                    print("Plugin directory %s successfully created"
                          % res)
                    print("but PLUGIN INSTALL ERROR")
                    print("%s" % b.stderr)
                    sys.exit(1)

        if args.delete:
            print("Deleting directory %s, keeping pluging file" %
                  args.plugin)
            for fic in glob.glob("*.plugin"):
                shutil.move(fic, "..")
            os.chdir("..")
            shutil.rmtree("%s/%s" % (os.getcwd(), args.plugin))

    else:
        print("Plugin directory %s successfully created" % res)
        print("but MAKE ERROR")
        print("%s" % b.stderr)
        sys.exit(1)

print()
print()
print("Plugin %s successfully created on directory %s" %
      (args.plugin, res))
print()
print()
if os.path.isfile("%s/README.md" % template_path):
    with open("%s/README.md" % template_path, "r") as f:
        mark = f.read()
    from rich.console import Console
    from rich.markdown import Markdown
    console = Console()
    md = Markdown(mark)
    console.print(md)
print()
print()

plugins_guide = "https://metwork-framework.org/pub/metwork/" \
    "continuous_integration/docs/integration/%s/350-plugin_guide/" % \
    MFMODULE_LOWERCASE
print("Whats next? Read the plugins guide at \n    %s" % plugins_guide)
