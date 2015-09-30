if defined?(ChefSpec)

  def add_rsync_serve(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:rsync_serve, :add, resource_name)
  end

  def remove_rsync_serve(resource_name)
    ChefSpec::Matchers::ResourceMatcher
      .new(:rsync_serve, :remove, resource_name)
  end
end
