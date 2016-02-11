class InvoiceController < ApplicationController
  # GET /invoices
  # GET /invoices.xml
  def index
    self.invoices_var = invoice_model.order('number desc')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => invoices_var }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    self.invoice_var = invoice_model.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => invoice_var }
      format.pdf
    end
  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    self.invoice_var = invoice_model.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => invoice_var }
    end
  end

  # GET /invoices/1/edit
  def edit
    self.invoice_var = invoice_model.find(params[:id])
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    self.invoice_var = invoice_model.new(invoice_params)

    respond_to do |format|
      if invoice_var.save
        format.html { redirect_to(invoice_var, :notice => "#{invoice.to_s.humanize.capitalize} creada correctamente.") }
        format.xml  { render :xml => invoice_var, :status => :created, :location => invoice_var }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => invoice_var.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    self.invoice_var = invoice_model.find(params[:id])
    
    deleted_items = eval params[:deleted][:items]
    deleted_items.each do |id|
      Item.find(id).destroy if (invoice_var.items.where(:id => id).exists?)
    end

    respond_to do |format|
      if (invoice_var.update_attributes(invoice_params))
        format.html { redirect_to(invoice_var, :notice => "#{invoice.to_s.humanize.capitalize} actualizada correctamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => invoice_var, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    self.invoice_var = invoice_model.find(params[:id])
    invoice_var.destroy

    respond_to do |format|
      format.html { redirect_to(eval "#{invoice.to_s.pluralize}_url") }
      format.xml  { head :ok }
    end
  end

  def summary
    fecha_base = Date.today.beginning_of_month
    meses = 11.downto(0).map do |m|
        fecha_base - m.month
    end

    info = invoice_model.where(:created_at => meses[0]..Time.now).group_by do |i|
        i.created_at.beginning_of_month
    end

    etiquetas_meses = meses.map do |m|
        I18n.l(m, format: '%B')
    end
    valores = meses.map do |m|
      info[m].nil? ? 0 : info[m].map {|i| i.total}.reduce(:+)
    end

    render json: {meses: etiquetas_meses, valores: valores}
  end

  private

  def invoice_var
      eval "@#{invoice.to_s}"
  end

  def invoice_var=(value)
      eval "@#{invoice.to_s} = value"
  end

  def invoices_var
      eval "@#{invoice.to_s.pluralize}"
  end

  def invoices_var=(value)
      eval "@#{invoice.to_s.pluralize} = value"
  end

  def invoice_model
      invoice.to_s.classify.constantize
  end

  def invoice_params
      cliente_permitted_params = [:nombre, :apellidos, :direccion, :ciudad, :provincia, :codigo_postal, :telefono, :nif]
      item_permitted_params = [:cantidad, :precio_unidad, :description]
      base_params = [:number, :created_at, cliente_attributes: cliente_permitted_params, items_attributes: item_permitted_params]
      if action_name == "update" then
          params.require(invoice).permit(*base_params, :id, cliente_attributes: cliente_permitted_params + [:id], items_attributes: item_permitted_params + [:id])
      else
          params.require(invoice).permit(*base_params)
      end
  end
end
