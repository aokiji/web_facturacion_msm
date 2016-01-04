prawn_document do |pdf|
    render :partial => 'invoice/show.pdf.prawn', :locals =>{:invoice => :presupuesto, :p_pdf => pdf, :title => %w{P r e s u p u e s t o}.join('  ')}
end
