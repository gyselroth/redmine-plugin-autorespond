require 'autorespond_mail_handler_controller_patch'
require 'autorespond_mailer_patch'

Redmine::Plugin.register :autorespond do
  name 'Autorespond plugin'
  author 'Fabian Jucker <jucker@gyselroth.com>'
  description 'This Redmine Plugin automatically responds to tickets created anonymously via mailhandler'
  version '0.0.1'
  url 'http://github.com/gyselroth'
  author_url 'http://www.gyselroth.com'

  settings :default => {'autorespond_body' => 'Thanks for your message. A new issue has been created and will be processes as soon as possible.'}, :partial => 'settings/autorespond_settings'
  project_module :autorespond do
    permission :autorespond, {}
  end
end
