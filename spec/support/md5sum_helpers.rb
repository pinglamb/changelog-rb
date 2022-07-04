# frozen_string_literal: true
require "digest"

module Md5sumHelpers
  def check_md5sum_of(folder)
    all  = Dir["#{folder}/**/*"]
    hash = all.select {|entry| File.file?(entry)}.each_with_object({}) {|e, h| h[Digest::MD5.hexdigest(File.read(e))] = e}.sort_by {|k,v| v}

    Digest::MD5.hexdigest(Marshal::dump(hash))
  end
end
