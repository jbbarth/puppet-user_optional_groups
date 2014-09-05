Puppet::Type.type(:user).newproperty(:optional_groups, :parent => Puppet::Property::List) do
  desc %w{Define optional groups you want to add only if they exist
    on the system. This is usually good for human users you want to put in some
    groups for comfort reasons or non-essential things. For instance, some logs on
    your platform might only be accessible for "staff" group. But not all your
    servers have this group defined (you may have heterogeneous environments).

    Values might be specified as a string or an array of string.
  }

  #validate format of value
  #copied from ":groups" property
  validate do |value|
    raise ArgumentError, "Group names must be provided, not GID numbers." if value =~ /^\d+$/
    raise ArgumentError, "Group names must be provided as an array, not a comma-separated list." if value.include?(",")
    raise ArgumentError, "Group names must not be empty. If you want to specify \"no groups\" pass an empty array" if value.empty?
  end

  #nullify value here if group doesn't exist
  munge do |value|
    value = nil if `getent group #{value}` == "" || `getent passwd #{resource.name}` == ""
    value
  end

  #how to retrieve current value
  def retrieve
    `id -nG #{@resource[:name]}`.split.sort
  end

  #remove nil values in any processing (see #munge method)
  def dearrayify(array)
    array.compact.sort.join(delimiter)
  end

  #set the new groups
  def set(groups)
    `usermod -a -G #{groups} #{@resource[:name]}`
  end
end
