render :partial => 'invoice/show.pdf.prawn', :locals =>{:invoice => :factura, :p_pdf => pdf, :title => %w{F a c t u r a}.join('  ')}
