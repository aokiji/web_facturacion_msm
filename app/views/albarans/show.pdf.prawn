prawn_document do |pdf|
    render :partial => 'invoice/show.pdf.prawn', :locals =>{:invoice => :albaran, :p_pdf => pdf, :title => %w{A l b a r a n}.join('  '), :taxes => false}
end
