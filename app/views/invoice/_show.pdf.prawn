title||=nil
taxes = true if taxes.nil?
@invoice = eval "@#{invoice}"
p_pdf.bounding_box [35, p_pdf.cursor], :width => p_pdf.bounds.width-70, :height => p_pdf.bounds.height-10 do

p_pdf.font_families.update(
  "Ubuntu" => {
    :regular => "#{Rails.root}/app/assets/stylesheets/fonts/MavenPro-Regular.ttf",
    :bold => "#{Rails.root}/app/assets/stylesheets/fonts/MavenPro-Medium.ttf"
  }
)
p_pdf.font("Ubuntu", :style => :regular)

# Titulo
p_pdf.fill_color '333333'
p_pdf.fill_rectangle [0, p_pdf.cursor], p_pdf.bounds.width, 25
p_pdf.fill_color 'ffffff'
p_pdf.text_box((title || invoice.to_s.capitalize), :size => 14, :width => p_pdf.bounds.width, :height => 20, :align => :center, :valign => :center, :style => :bold)
p_pdf.fill_color "000000"

p_pdf.move_down(50)

# left BB
bb1_width = p_pdf.bounds.width-150
bb2_width = p_pdf.bounds.width-bb1_width
bb1 = p_pdf.bounding_box [0, p_pdf.cursor], :width => bb1_width do
  items = [['Número', @invoice.number], ['Fecha', I18n.localize(@invoice.created_at)]] 
  p_pdf.table items, :width => 150, :column_widths => {0 => 60}  do
    cells.style :border_style => :grid, :border_width=> 0.5, :size => 9, :align => :left
    style(column(0), :text_color => 'ffffff', :size => 9, :align => :left, :background_color => '4D4D4D', :font_style => :bold)
    style(column(0), :text_color => 'ffffff', :size => 9, :align => :left, :background_color => '4D4D4D', :font_style => :bold)
  end
  p_pdf.move_down(15)
  p_pdf.text 'Cliente', :size => 11, :style => :bold
  p_pdf.move_down(8)
  items = @invoice.cliente.sorted_non_empty_attr.map do |x, y|
    [{:content => "#{x.humanize.capitalize}", :text_color => '222222'}, {:content => y}]
  end
  bb = p_pdf.bounding_box [0, p_pdf.cursor], :width => 280 do
    p_pdf.table items, :column_widths => {0 => 80}, :width => 280 do
      cells.style :border_style => :grid, :size => 8, :border_width => 0.5
      style(column(0), :align => :left, :background_color => "4D4D4D", :font_style => :bold, :text_color => "ffffff", :size => 9)
      style(column(1), :align => :left, :size => 9)
    end
  end
  p_pdf.move_up(bb.height)
  p_pdf.fill_color 'ffffff'
  
  p_pdf.move_down(bb.height)
  p_pdf.move_down(20)
end

# right BB
p_pdf.move_up(bb1.height)
bb2=p_pdf.bounding_box [bb1_width, p_pdf.cursor], :width => bb2_width do
  p_pdf.image Rails.root.join('public', 'images', 'msm.logo.jpg'), :width => 160
  p_pdf.fill_color "333333"
  p_pdf.bounding_box [0, p_pdf.cursor], :width => 160 do
    invoice.to_s.classify.constantize::MSM_INFO.each do |text|
      p_pdf.text text, :size => 8, :align => :center
    end
  end
  p_pdf.fill_color '000000'
  p_pdf.move_down(20)
end

if bb2.height < bb1.height
  p_pdf.move_up bb2.height-bb1.height
end

# DETALLE
p_pdf.fill_color '000000'
p_pdf.text 'Detalle', :size => 11, :style => :bold
p_pdf.move_down(8)
items = [["Cantidad", "Precio Unidad", "Descripcion", "Precio Total"]]
items += @invoice.items.map do |item|
  [
    item.cantidad,
    number_to_currency(item.precio_unidad),
    item.description,
    number_to_currency(item.total)
  ]
end

if taxes
  items.push([{:content => "",:borders => [:top]}]*2 + [{:content => "Subtotal", :borders => [:top]}, number_to_currency(@invoice.subtotal)])
  items.push([{:content => "",:borders => []}]*2 + [{:content => "Impuesto (#{@invoice.impuesto}%)", :borders => []}, number_to_currency(@invoice.impuesto_subtotal)])
  items.push([{:content => "",:borders => []}]*2 + [{:content => "Total", :borders => []}, number_to_currency(@invoice.total)])
else
  items.push([{:content => "",:borders => [:top]}]*2 + [{:content => "Total", :borders => [:top]}, number_to_currency(@invoice.total)])
end

p_pdf.table items, :header => true, :width => p_pdf.bounds.width,
  :row_colors => ["FFFFFF"],
  :header => true, 
  :column_widths=>{0 => 70.0, 1 => 70.0, 3=>100} do
    cells.style :border_color => '222222', :border_style => :grid, :size => 9, :align => :center, :valign => :center, :border_width => 0.5
    style(row(0), :background_color => '4D4D4D', :text_color => 'ffffff')
    (1..(taxes ? 3 : 1)).each do |i|
      cells[row_length - i, 2].style(:align => :right)
    end
  end
end
# FOOTERS
p_pdf.number_pages "Página <page> de <total>", {:align => :right, :size => 8, :at => [p_pdf.bounds.right - 50, 0]}
