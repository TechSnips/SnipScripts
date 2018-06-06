# Install and import PoshBot
Install-Module -Name PoshBot -Repository PSGallery -Scope CurrentUser
Import-Module -Name PoshBot

# Create a bot token
# https://my.slack.com/services/new/bot

# Make note of your Slack username
# Replace 'poshbot-techsnips' with your Slack workspace name
# https://poshbot-techsnips.slack.com/account/settings#username

# Create bot configuration
$botParams = @{
    Name = 'poshbot'
    BotAdmins = @('<SLACK-USERNAME>')
    CommandPrefix = '!'
    LogLevel = 'Info'
    BackendConfiguration = @{
        Name = 'SlackBackend'
        Token = '<SLACK-TOKEN>'
    }
}
$botConfig = New-PoshBotConfiguration @botParams
$botConfig | Format-List

# Create backend instance
$backend = New-PoshBotSlackBackend -Configuration $botConfig.BackendConfiguration
$backend | Format-List

# Create and start bot
$bot = New-PoshBotInstance -Configuration $botConfig -Backend $backend
$bot | Format-List
$bot | Start-PoshBot -Verbose
