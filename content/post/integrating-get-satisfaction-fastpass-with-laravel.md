+++
Topics = ["development"]
date = "2014-01-09T08:54:57-05:00"
Description = "Overview of what is involved in getting your Laravel 4 apps authentication system to integrate with Get Satisfaction Fastpass for single sign on."
Keywords = ["laravel", "php", "fastpass"]
Tags = ["laravel", "php", "fastpass"]
Slug = "integrating-get-satisfaction-fastpass-with-laravel"
Title = "Integrating Get Satisfaction Fastpass with Laravel"
+++

Here is an overview of what is involved in getting your Laravel 4 apps authentication system to integrate with Get Satisfaction Fastpass for single sign on.

## What I am using
* [Laravel 4.0][2]
* [Cartalyst Sentry 2][3] (for authentication)
* [Former][4]
* [Fastpass PHP SDK][1]

## Install the Fastpass PHP SDK

**Create a folder to install the library in**
```
$ mkdir app/lib
$ mkdir app/lib/getsatisfaction
```
**Download & untar/unzip the Fastpass PHP SDK**
```
cd app/lib/getsatisfaction
wget "https://getsatisfaction.com/fastpass/php.tar.gz"
tar -zxvf php.tar.gz .
```

**Update** *composer.json* **adding the location of the library**

In the *autoload* section add the path *app/lib/getsatisfaction*
```
"autoload": {
        "classmap": [
            "app/commands",
            "app/controllers",
            "app/models",
            "app/database/migrations",
            "app/database/seeds",
            "app/tests/TestCase.php",
            "app/lib/getsatisfaction"
        ]
    },
```

**In the console run**
```
$ composer update
$ php artisan dump-autoload
```

**Create a configuration file (e.g. app/config/getsatisfaction.php ) to hold your API tokens for the Fastpass service**

```php
<?php

return array(
    'key' => '<your fastpass key>',
    'secret' => '<your fastpass secret>',
    'domain' => '<your domain for your get satisfaction commmunity>',
);
```

The above information can be found in the admin section once you log in as administrator on <http://getsatisfaction.com>.

## Create a login screen for Single Sign on

We now need to create a login form to be used by the Fastpass service to use our authentication service provided by sentry to log users into Get Satisfaction.

**First we create a new controller** *app/controllers/SatisfactionController.php*

```php
<?php

use App\Services\Validators\UserValidator;
use Cartalyst\Sentry\Users;

class SatisfactionController extends BaseController
{
    /**
     * Authenticate the user
     *
     * @author Salar Rahmanian
     * @link   http://www.softinio.com
     *
     *
     * @return Response
     */
    public function postLogin()
    {
        $remember = Input::get('remember_me', false);
        $userdata = array(
            Config::get('cartalyst/sentry::users.login_attribute') => Input::get('login_attribute'),
            'password'                                             => Input::get('password')
        );
        try {
            // Log user in
            $user = Sentry::authenticate($userdata, $remember);
        } catch (LoginRequiredException $e) {
            return Redirect::back()->withInput()->with('error', $e->getMessage());
        } catch (PasswordRequiredException $e) {
            return Redirect::back()->withInput()->with('error', $e->getMessage());
        } catch (WrongPasswordException $e) {
            return Redirect::back()->withInput()->with('error', $e->getMessage());
        } catch (UserNotActivatedException $e) {
            return Redirect::back()->withInput()->with('error', $e->getMessage());
        } catch (UserNotFoundException $e) {
            return Redirect::back()->withInput()->with('error', $e->getMessage());
        } catch (UserSuspendedException $e) {
            return Redirect::back()->withInput()->with('error', $e->getMessage());
        } catch (UserBannedException $e) {
            return Redirect::back()->withInput()->with('error', $e->getMessage());
        } catch (Exception $e) {
            return Redirect::back()->withInput()->with('error', $e->getMessage());
        }

        Event::fire('users.login', array($user));

        // Log user into Get Satisfaction service
        return View::make('satisfaction.index', compact('user'));
    }

    /**
     * Show the login form
     *
     * @author Salar Rahmanian
     * @link   http://www.softinio.com
     *
     * @return Response
     */
    public function getLogin()
    {
        // Check to see if user logged in, if not show login form
        if (!\Sentry::check()) {
            $login_attribute = Config::get('cartalyst/sentry::users.login_attribute');
            return View::make('satisfaction.login', compact('login_attribute'));
        }

        // user already logged in so log them into Get Satisfaction service
        $user = \Sentry::getUser();

        return View::make('satisfaction.index', compact('user'));
    }
}
```
Now we need to create the two views used by this controller, one with a login form and one view which logs the user into the get satisfaction service.

For the login form we create the view *app/views/satisfaction/login.blade.php*

This can be a copy of the login form you currently use within your Laravel app but with the form action changed to use the new *SatisfactionController*.

```
@extends('layouts.master')

@section('h1')
<h1>Sign In</h1>
@stop

@section('crumb')
    <li><a href="{{ url('/satisfaction/index') }}">User</a></li>
    <li class="active">Login</li>
@stop

@section('title')
Sign In -
@stop

@section('container')
<div class="row">
    <div class="col-lg-offset-2 col-lg-6 col-md-offset-2 col-md-6">
        {{ Former::horizontal_open(url('/satisfaction/login')) }}

            {{ Former::text('login_attribute', 'User Name',Input::old('login_attribute'))->required() }}

            {{ Former::password('password', 'Password')->required() }}
            {{ Former::checkbox('remember_me','&nbsp;')->text('Remember me on this computer') }}


        <div class="col-lg-offset-3 col-sm-offset-4 col-lg-9 col-sm-8">
            {{ Former::primary_submit('Log in') }}
            <a href="{{ URL::route('user.register') }}" class="pull-right">Register Here</a>
        </div>



        </form>
    </div>
</div>
@stop
```

**We create the view that logs user into Get Satisfaction** *app/views/satisfaction/index.blade.php*

This is in effect a blank html document which calls the php class from the Fastpass library to log the current user into the Get Satisfaction service.

```
<!DOCTYPE html>


{{    \FastPass::$domain = \Config::get('getsatisfaction.domain'); }}
{{    \FastPass::script(\Config::get('getsatisfaction.key'),
                      \Config::get('getsatisfaction.secret'),
                     $user->email,
                     $user->username,
                     $user->id,
                     true
                     ); }}

<html lang="en" class="env_<?php echo App::environment(); ?>">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">
        <link rel="shortcut icon" href="/assets/ico/favicon.png">

        <title>@yield('title') softinio.com </title>

        <!-- Bootstrap core CSS -->
        {{ basset_stylesheets('bootstrap','application') }}

        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!--[if lt IE 9]>
        {{ basset_javascripts('html5') }}
        <![endif]-->
    </head>


    <body>

    </body>
</html>
```
The users email , username and user id provided by Sentry are used to create and log user into the Get Satisfaction service. The username is what will be displayed as the logged in user on Get Satisfaction website so if you prefer something else you can substitute username for what you prefer.

**Update your** *app/routes.php* **file**

```php
Route::get('satisfaction/login', 'SatisfactionController@getLogin');
Route::post('satisfaction/login','SatisfactionController@postLogin');
```

## Update Get Satisfaction with your login URL

Based on the new route you created for the *SatisfactionController* your URL to your single sign on should be
```
http://<yourdomain where your laravel app is>/satisfaction/login
```

Log into Get Satifaction as admin, click the wheel settings menu, select Configure then select Fastpass. Here set your *External Login URL* to this and click save.

Whilst you are logged in as admin you can also click login options and select Fastpass as your preferred login method.


[1]: https://getsatisfaction.com/fastpass/php.tar.gz
[2]: http://laravel.com
[3]: https://cartalyst.com/manual/sentry
[4]: http://anahkiasen.github.io/former
