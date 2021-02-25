# frozen_string_literal: true

require 'pronto'
require 'rubocop'

# dirty patch
module RuboCop
  class Config
    def base_dir_for_path_parameters
      ENV.fetch("PRONTO_RUBOCOP_WORKSPACE") { Dir.pwd }
    end
  end
end

require 'pronto/rubocop/patch_cop'
require 'pronto/rubocop/offense_line'

module Pronto
  class Rubocop < Runner
    def run
      ruby_patches
        .select { |patch| patch.additions.positive? }
        .flat_map { |patch| PatchCop.new(patch, self).messages }
    end

    def pronto_rubocop_config
      @pronto_rubocop_config ||= Pronto::ConfigFile.new.to_h['rubocop'] || {}
    end
  end
end