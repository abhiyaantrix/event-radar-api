# frozen_string_literal: true

class BaseSerializer

  include Alba::Resource

  root_key!

  transform_keys :lower_camel, root: true

end
