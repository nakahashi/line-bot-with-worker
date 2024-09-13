module Line
  module Bot
    class Client
      def validate_signature(body, signature)
        true
      end

      def reply_message(token, message)
        p "#reply_message token: #{token}, message: #{message}"
      end
    end
  end
end
