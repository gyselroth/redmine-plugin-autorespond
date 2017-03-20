require_dependency 'mailer'

module AutorespondMailerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end
  
  module InstanceMethods
    def custom_mail(issue, from, content)
        redmine_headers 'Project' => issue.project.identifier,
            'Issue-Id' => issue.id,
            'Issue-Author' => issue.author.login
        redmine_headers 'Issue-Assignee' => issue.assigned_to.login if issue.assigned_to
        message_id issue
        references issue
        @content = content
        mail :to => from,
            :subject => "[#{issue.project.name} - #{issue.tracker.name} ##{issue.id}] (#{issue.status.name}) #{issue.subject}"
    end

  end

end

Mailer.send(:include, AutorespondMailerPatch)
