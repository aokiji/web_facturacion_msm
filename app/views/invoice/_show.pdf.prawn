title||=nil
taxes = true if taxes.nil?
@invoice = eval "@#{invoice}"
p_pdf.bounding_box [0, p_pdf.cursor], :width => p_pdf.bounds.width, :height => p_pdf.bounds.height-10 do

p_pdf.font 'Helvetica'

# Titulo
p_pdf.fill_color '222222'
p_pdf.fill_rectangle [0, p_pdf.cursor], p_pdf.bounds.width, 20
p_pdf.fill_color "ffffff" 
p_pdf.text_box((title || invoice.to_s.capitalize), :size => 14, :width => p_pdf.bounds.width, :height => 22, :align => :center, :valign => :center, :font => 'Helvetica Neue')
p_pdf.fill_color "000000"

p_pdf.move_down(40)

# left BB
bb1_width = p_pdf.bounds.width-150
bb2_width = p_pdf.bounds.width-bb1_width
bb1 = p_pdf.bounding_box [0, p_pdf.cursor], :width => bb1_width do
  items = [[{:text => 'Número:', :font_style => :bold, :text_color => '222222'}, @invoice.number], [{:text =>'Fecha:', :font_style => :bold, :text_color => '222222'}, I18n.localize(@invoice.created_at)]]
  p_pdf.table items, :width => 130, :border_style => :grid, :border_width=> 0, :font_size => 8, :align => { 0 => :right, 1 => :left}, :column_widths => {0 => 60}
  p_pdf.move_down(15)
  p_pdf.text 'Cliente', :size => 10
  p_pdf.move_down(8)
  items = @invoice.cliente.sorted_non_empty_attr.map do |x, y|
    [{:text => "#{x.humanize.capitalize}:", :font_style => :bold, :text_color => '222222'}, {:text => y}]
  end
  bb = p_pdf.bounding_box [0, p_pdf.cursor], :width => 220 do
    p_pdf.table items, :border_style => :grid, :font_size => 8, :border_width => 0, :align => {0 => :right, 1 => :left}, :column_widths => {0 => 60}, :width => 220
  end
  p_pdf.move_up(bb.height)
  p_pdf.fill_color 'ffffff'
  p_pdf.stroke_rounded_rectangle([0, p_pdf.cursor], bb.width, bb.height, 10)
  p_pdf.move_down(bb.height)
  p_pdf.move_down(20)
end

# right BB
p_pdf.move_up(bb1.height)
bb2=p_pdf.bounding_box [bb1_width, p_pdf.cursor], :width => bb2_width do
  p_pdf.image Rails.root.join('public', 'images', 'msm.logo.jpg'), :width => 160
  p_pdf.move_down(20)
  p_pdf.fill_color "333333"
  p_pdf.bounding_box [0, p_pdf.cursor], :width => 160 do
    invoice.to_s.classify.constantize::MSM_INFO.each do |text|
      p_pdf.text text, :size => 8, :style => :bold, :align => :center
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
p_pdf.text 'Detalle', :size => 10
p_pdf.move_down(8)
items = @invoice.items.map do |item|
  [
    item.cantidad,
    number_to_currency(item.precio_unidad),
    item.description,
    number_to_currency(item.total)
  ]
end

if taxes
  items.push([{:text => "",:borders => [:top]}]*2 + [{:text => "Subtotal", :borders => [:top], :align => :right}, number_to_currency(@invoice.subtotal)])
  items.push([{:text => "",:borders => []}]*2 + [{:text => "Impuesto (#{@invoice.impuesto}%)", :borders => [], :align => :right}, number_to_currency(@invoice.impuesto_subtotal)])
  items.push([{:text => "",:borders => []}]*2 + [{:text => "Total", :borders => [], :align => :right}, number_to_currency(@invoice.total)])
else
  items.push([{:text => "",:borders => [:top]}]*2 + [{:text => "Total", :borders => [:top], :align => :right}, number_to_currency(@invoice.total)])
end

p_pdf.table items, :border_style => :grid, :header => true, :width => p_pdf.bounds.width,
  :row_colors => ["FFFFFF"],
  :headers => ["Cantidad", "Precio Unidad", "Descripcion", "Precio Total"],
  :align => { 0 => :center, 1 => :center, 2 => :center, 3 => :center },
  :cell_style => {:border_color => '444444'},
  :header_color => '444444',
  :header_text_color => 'ffffff',
  :font_size => 8,
  :border_color => '222222',
  :valign => :center,
  :column_widths=>{0 => 70.0, 1 => 70.0, 3=>100}
end
# FOOTERS
total_pages = p_pdf.page_count 
p_pdf.pages.each_with_index do |page, num_pag|
  p_pdf.go_to_page(num_pag+1)
  p_pdf.bounding_box [p_pdf.margin_box.left, p_pdf.margin_box.bottom + 10], :width => p_pdf.bounds.width do
    p_pdf.font "Helvetica" do 
      p_pdf.text "Página #{num_pag+1} de #{p_pdf.page_count}", 
        :align => :center, :size => 8, :align => :right  
    end 
  end
end
