module ApplicationHelper
    def nav_button_for(controller, name, html_options = nil)
        html_options[:class] ||= ""
        classes = ['menu01']
        if controller.to_s == params[:controller] then
            classes += ['active']
        end
        html_options[:class] = (html_options[:class].split + classes).uniq.join(' ')

        content_tag('a', name, html_options)
    end
end
