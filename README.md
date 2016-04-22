# Eight Bit Stand-up Bot
Wouldn't it be cool if we could skip some meetings and just have our stand-up via chat? Well now we can!

### Bot Setup
You will need to create a file `./.env` to setup your environment variables.  The current environment variables required in this file are:

* `ENV['HIPCHAT_JID']`
* `ENV['HIPCHAT_PASSWORD']`

You may need to set your server host for the rails app that feeds us our API.  You can configure this in the specific environment files located in the `./config/environment` folder.

### Generating Handlers
We are using the `lita-ext` gem to help organize our files similar to rails.  This gives us some helpers, and one of those is an easy way to register any handlers we create.  Create your handlers using the command `lita-ext handler NAME` and this will create a handler in the location `app/handlers/name.rb`.
