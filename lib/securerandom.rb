# Because we're stuck on 1.8.7 for the time being...

# https://github.com/ruby/ruby/blob/19b2909ee87c67fae96f77637b3245b81cbce722/lib/securerandom.rb#L182
module SecureRandom
  def self.urlsafe_base64(n=nil, padding=false)
    s = [random_bytes(n)].pack("m*")
    s.delete!("\n")
    s.tr!("+/", "-_")
    s.delete!("=") unless padding
    s
  end
end
