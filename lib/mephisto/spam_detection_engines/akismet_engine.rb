module Mephisto
  module SpamDetectionEngines
    class AkismetEngine < Mephisto::SpamDetectionEngine::Base
      def ham?(permalink_url, comment)
        check_valid!
        !akismet.comment_check(comment_spam_options(permalink_url, comment))
      end

      def mark_as_ham(permalink_url, comment)
        check_valid!
        akismet.submit_ham(comment_spam_options(permalink_url, comment))
      end

      def mark_as_spam(permalink_url, comment)
        check_valid!
        akismet.submit_spam(comment_spam_options(permalink_url, comment))
      end

      def valid?
        [:akismet_key, :akismet_url].all? { |attr| !options[attr].blank? }
      end

      def valid_key?
        false
      end

      protected
      def akismet
        @akismet ||= ::Akismet.new(options[:akismet_key], options[:akismet_url])
      end

      def comment_spam_options(permalink_url, comment)
        { :user_ip              => comment.author_ip, 
          :user_agent           => comment.user_agent, 
          :referrer             => comment.referrer,
          :permalink            => permalink_url, 
          :comment_author       => comment.author, 
          :comment_author_email => comment.author_email, 
          :comment_author_url   => comment.author_url, 
          :comment_content      => comment.body}
      end

      def check_valid!
        raise Mephisto::SpamDetectionEngine::NotConfigured unless self.valid?
      end
    end
  end
end
