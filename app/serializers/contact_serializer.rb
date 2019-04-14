# frozen_string_literal: true

class ContactSerializer; end

# TODO: Uncomment this and remove the above dummy class when Rails 6 is released.
# class ContactSerializer < ActiveJob::Serializers::ObjectSerializer
#   def serialize?(argument)
#     argument.is_a?(Contact)
#   end

#   def serialize(contact)
#     super(
#       'name' => contact.name,
#       'email' => contact.email,
#       'subject' => contact.subject,
#       'body' => contact.body
#     )
#   end

#   def deserialize(hash)
#     Contact.new(name: hash['name'], email: hash['email'], subject: hash['subject'], body: hash['body'])
#   end
# end
