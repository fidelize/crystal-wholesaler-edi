module Edi
  class Config
    @@directory = "files/"
    @@secret = "secret"

    def self.directory
      @@directory
    end

    def self.secret
      @@secret
    end

    def self.directory=(directory)
      @@directory = directory
    end

    def self.secret=(secret)
      @@secret = secret
    end
  end
end
