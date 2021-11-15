# frozen_string_literal: true

shortcut = Slim::Parser.options[:shortcut]
shortcut["~"] = {attr: "test_id"}

return if Rails.env.test?

class SlimTestIdFilter < Temple::HTML::Filter
  def on_html_attrs(*attrs)
    [:html, :attrs, *attrs.map { |attr| compile(attr) }.compact]
  end

  def on_html_attr(name, value)
    return if name == "test_id"

    super
  end
end

Slim::Engine.after Slim::Controls, SlimTestIdFilter
