hublr
=======

```

oooo                     .o8       oooo
`888                    "888       `888
 888 .oo.   oooo  oooo   888oooo.   888  oooo d8b
 888P"Y88b  `888  `888   d88' `88b  888  `888""8P
 888   888   888   888   888   888  888   888
 888   888   888   888   888   888  888   888
o888o o888o  `V88V"V8P'  `Y8bod8P' o888o d888b

```

A Chrome extension for nerds.


# Design Doc

Expect this document to change a lot as development continues. :warning:

## Introduction

**Hublr** is a Chrome extension that adds useful social features to Github.
Hublr extends Github's functionality using **Extensions**, modules that are
dynamically injected into the page and can be enabled or disabled by the user.


## Managing application state

Hublr uses Redux to manage the application state in a single Store.
The Store is saved to localstorage periodically, and is also used to cache the
responses from Github API calls.

```js
{
    /* Config stores the configuration for Hublr and its extension */
    "config": {
        /* User's oauth credentials */
        "credentials": {
            "username": "",
            "oauth_token": "",
            "oauth_secret": ""
        },
        /* Settings for different extensions */
        "extensions": {
            "newsfeed": {
                "enabled": true
            }
        },
        /* Settings for the cache */
        "cache": {
            "timeout": "..." /* Expiration time for cache */
        }
    },
    /* Cache stores the responses of API calls. It is a mapping of
    Github API routes to responses/dates */
    "cache": {
        "/v3/users/ali": {
            "response": { /* response data */ },
            "datetime": "...", /* date response was cached */
        }
    }
}
```
