# frozen_string_literal: true

Alba.backend = :oj_rails # faster than active_support

# Auto infers attributes from objects
# Intentionally disabled considering security implications of accidentally exposing sensitive attributes
# Better to be explicit about what is being included in responses
# Alba.enable_inference!(with: :active_support)
