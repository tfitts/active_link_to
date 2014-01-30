module ActiveLinkTo
  
  # Wrapper around link_to. Accepts following params:
  #   :active         => Boolean | Symbol | Regex | Controller/Action Pair
  #   :class_active   => String
  #   :class_inactive => String
  #   :disable_active => Boolean
  #   :wrap_tag       => Symbol
  # Example usage:
  #   active_link_to('/users', :class_active => 'enabled')
  #   active_link_to(users_path, :active => :exclusive, :wrap_tag => :li)
  def active_link_to(*args, &block)
    if block_given?
      wrap_tag_contents = capture(&block)
      name          = args[0]
      options       = args[1] || {}
      html_options  = args[2] || {}
    else
      wrap_tag_contents = ''
      name          = args[0]
      options       = args[1] || {}
      html_options  = args[2] || {}
    end
    url = url_for(options)

    active_options  = { }
    link_options    = { }
    html_options.each do |k, v|
      if [:active, :class_active, :class_inactive, :active_disable, :wrap_tag, :wrap_tag_class_active, :wrap_tag_class_inactive, :wrap_tag_class].member?(k)
        active_options[k] = v
      else
        link_options[k] = v
      end
    end

    css_class = link_options.delete(:wrap_tag_class).to_s + ' '
    css_class << active_link_to_class(url, active_options)
    css_class.strip!

    wrap_css_class = active_options.delete(:wrap_tag_class).to_s + ' '
    wrap_css_class << active_link_to_wrap_class(url, active_options)
    wrap_css_class.strip!

    wrap_tag = active_options[:wrap_tag].present? ? active_options[:wrap_tag] : nil
    link_options[:class] = css_class if css_class.present?

    link = if active_options[:active_disable] === true && is_active_link?(url, active_options[:active])
      content_tag(:span, name, link_options)
    else
      link_to(name, url, link_options)
    end

    wrap_tag ? content_tag(wrap_tag, link << wrap_tag_contents, :class => (wrap_css_class if wrap_css_class.present?)) : link
  end

  # Returns css class name. Takes the link's URL and its params
  # Example usage:
  #   active_link_to_class('/root', :class_active => 'on', :class_inactive => 'off')
  #
  def active_link_to_class(url, options = {})
    if is_active_link?(url, options[:active])
      options[:class_active] || 'active'
    else
      options[:class_inactive] || ''
    end
  end

  # Returns css class name. Takes the link's URL and its params
  # Example usage:
  #   active_link_to_wrap_class('/root', :class_active => 'on', :class_inactive => 'off')
  #
  def active_link_to_wrap_class(url, options = {})
    if is_active_link?(url, options[:active])
      options[:wrap_tag_class_active] || 'active'
    else
      options[:wrap_tag_class_inactive] || ''
    end
  end

  # Returns true or false based on the provided path and condition
  # Possible condition values are:
  #                  Boolean -> true | false
  #                   Symbol -> :exclusive | :inclusive
  #                    Regex -> /regex/
  #   Controller/Action Pair -> [[:controller], [:action_a, :action_b]]
  # Example usage:
  #   is_active_link?('/root', true)
  #   is_active_link?('/root', :exclusive)
  #   is_active_link?('/root', /^\/root/)
  #   is_active_link?('/root', ['users', ['show', 'edit']])
  #
  def is_active_link?(url, condition = nil)
    url = url_for(url).sub(/\?.*/, '') # ignore GET params
    case condition
    when :inclusive, nil
      !request.fullpath.match(/^#{Regexp.escape(url).chomp('/')}(\/.*|\?.*)?$/).blank?
    when :exclusive
      !request.fullpath.match(/^#{Regexp.escape(url)}\/?(\?.*)?$/).blank?
    when Regexp
      !request.fullpath.match(condition).blank?
    when Array
      controllers = [*condition[0]]
      actions     = [*condition[1]]
      (controllers.blank? || controllers.member?(params[:controller])) &&
      (actions.blank? || actions.member?(params[:action]))
    when TrueClass
      true
    when FalseClass
      false
    end
  end
end

ActionView::Base.send :include, ActiveLinkTo
