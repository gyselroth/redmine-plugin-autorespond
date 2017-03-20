require_dependency 'mail_handler_controller'

module AutorespondMailHandlerControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :index, :autoresponse
    end
  end
  
  module InstanceMethods
    # Adds a rates tab to the user administration page
    def index_with_autoresponse
        options = params.dup
        email = options.delete(:email)
        result = MailHandler.receive(email, options)
        logger.info "autoresponse plugin"
        if result.is_a?(Issue) and result.author.anonymous? and result.project.enabled_modules.any?{|mod| mod.name == :autorespond.to_s }
            from = address_from_email(email)
            Mailer.custom_mail(result, from, Setting.plugin_autorespond['autorespond_body']).deliver
        end
        if result
            head :created
        else
            head :unprocessable_entity
        end
    end

    private
    def address_from_email(email)
        mail = Mail.new(email)
        from = mail.header['from'].to_s
        addr, name = from, nil
        if m = from.match(/^"?(.+?)"?\s+<(.+@.+)>$/)
            addr, name = m[2], m[1]
        end
        return addr
    end
  end
end

MailHandlerController.send(:include, AutorespondMailHandlerControllerPatch)
