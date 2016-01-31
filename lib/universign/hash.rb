class Hash
  unless Hash.respond_to? :reverse_merge
    def reverse_merge(other_hash)
      other_hash.merge(self)
    end
  end
end
