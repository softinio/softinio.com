+++
categories = ["development", "python"]
date = "2015-04-13T09:06:03-05:00"
description = "Using pyenv to manage your virtual environments makes working on multiple projects, each using a different version of python a breeze."
slug = "using-pyenv-for-python-projects"
tags = ["python", "pyenv", "centos"]
keywords = ["python", "pyenv", "centos"]
title = "Using pyenv for Python projects"

+++

Using [pyenv][3] to manage your virtual environments makes working on multiple projects, each using a different version of python a breeze.

I do all my development on an Apple Macbook running Yosemite and my production environment is a VPS from [Linode][1] running [CentOS 7][2].

Here some simple notes on how I setup and use [pyenv][3] :

## Installing on Mac OS X ##

*Install Using [homebrew][5]*

```
$ brew install pyenv pyenv-virtualenv
```

**Update your shell profile (.bashrc or .zshrc) adding the following to it (and restart your terminal)**

```
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
```


## Installing on Linux CentOS 7 ##

**Checkout from github**

```
$ git clone https://github.com/yyuu/pyenv.git ~/.pyenv
$ git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
```

**Update your shell profile (.bashrc or .zshrc) adding the following to it (and restart your terminal)**

```
$ echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
$ echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
$ echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
```

## Using pyenv ##

**To install a new version of [Python][6]**

```
$ pyenv install <version>
$ pyenv rehash
```

**To get a list of [Python][6] versions available**

```
$ pyenv install -l
```

**To create a new virtual environment**

```
$ pyenv virtualenv [pyenv-version] [virtualenv-name]
```

**To use your new virtual environment within your project**

1. Change to your projects root directory
1. Run:
```
$ pyenv local [virtualenv-name]
```
Note that this is done only the first time you go to your project directory. The wonderful thing about [pyenv][3] is in future when you change directory to your project directory, it will be automatically activated your virtualenv for you.

[1]: https://www.linode.com
[2]: https://www.centos.org
[3]: https://github.com/yyuu/pyenv
[4]: https://github.com/yyuu/pyenv-virtualenv
[5]: http://brew.sh
[6]: https://www.python.org
