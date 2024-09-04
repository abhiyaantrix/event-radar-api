# frozen_string_literal: true

require 'active_record/connection_adapters/postgresql_adapter'

module DisablePreparedStatements

  def initialize(config)
    new_config = config.merge(prepared_statements: false) # build a new hash where prepared_statements is false
    super(new_config)
  end

end

ActiveSupport.on_load(:active_record_postgresqladapter) { prepend DisablePreparedStatements }
