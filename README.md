# Eight Bit Stand-up Bot
Wouldn't it be cool if we could skip some meetings and just have our stand-up via chat? Well now we can!

### Bot Setup
You will need to create a file `config/application.yml` to setup your credentials.

*application.yml*

    defaults: &defaults
      hipchat:
        jid: YOUR_BOTS_JID@chat.hipchat.com
        password: YOUR_BOTS_PASSWORD
    test:
      <<: *defa
    development:
      <<: *defa
    staging:
      <<: *defa
    production:
      <<: *defaults

