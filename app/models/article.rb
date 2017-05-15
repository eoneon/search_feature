class Article < ActiveRecord::Base

  scope :with_author, -> { where(author: "Gunnar") }

  def get_hash(params_hsh)
    params_hsh.delete_if { |k, v| v.nil? }
  end

  #call chained scopes
  def self.send_chain(get_hash)
    hsh = get_hash.keys.map { |k| "with_" + k }
    hsh.inject(self, :send)
  end
  # def self.send_chain(params_hsh)
  #   hsh = params_hsh.delete_if { |k, v| v.nil? }
  #   kys = hsh.keys
  #   methods = kys.map { |k| "with_" + k }
  #   methods.inject(self, :send)
  # end
end
