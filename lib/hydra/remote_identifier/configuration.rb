module Hydra::RemoteIdentifier

  class Configuration
    attr_reader :remote_service_namespace_container
    def initialize(remote_service_namespace_container = Hydra::RemoteIdentifier::RemoteServices)
      @remote_service_namespace_container = remote_service_namespace_container
    end

    def remote_service(service_name)
      remote_service_class_lookup(service_name).new
    end

    def register_remote_service(service_name, *args, &block)
      remote_service_class_lookup(service_name).configure(*args, &block)
    end

    private

    def remote_service_class_lookup(string)
      remote_service_class_name = string.to_s.gsub(/(?:^|_)([a-z])/) { $1.upcase }
      if remote_service_namespace_container.const_defined?(remote_service_class_name)
        remote_service_namespace_container.const_get(remote_service_class_name)
      else
        raise NotImplementedError.new(
          "Unable to find #{self} remote_service '#{string}'. Consider creating #{remote_service_namespace_container}::#{remote_service_class_name}"
        )
      end
    end
  end

end