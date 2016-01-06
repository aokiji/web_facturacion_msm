class InvoiceController < ApplicationController
  # GET /invoices
  # GET /invoices.xml
  def index
    eval "@#{invoice.to_s.pluralize} = invoice.to_s.classify.constantize.order('number desc')"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => (eval "@#{invoice.to_s.pluralize}") }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    eval "@#{invoice} = invoice.to_s.classify.constantize.find(params[:id])"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => (eval "@#{invoice}") }
      format.pdf
    end
  end

  # GET /invoices/new
  # GET /invoices/new.xml
  def new
    eval "@#{invoice} = invoice.to_s.classify.constantize.new"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => (eval "@#{invoice}") }
    end
  end

  # GET /invoices/1/edit
  def edit
    eval "@#{invoice} = invoice.to_s.classify.constantize.find(params[:id])"
  end

  # POST /invoices
  # POST /invoices.xml
  def create
    eval "@#{invoice} = invoice.to_s.classify.constantize.new(invoice_params)"

    respond_to do |format|
      if eval "@#{invoice}.save"
        format.html { redirect_to((eval "@#{invoice}"), :notice => "#{invoice.to_s.humanize.capitalize} creada correctamente.") }
        format.xml  { render :xml => (eval "@#{invoice}"), :status => :created, :location => (eval "@#{invoice}") }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => (eval "@#{invoice}.errors"), :status => :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.xml
  def update
    eval "@#{invoice} = invoice.to_s.classify.constantize.find(params[:id])"
    
    deleted_items = eval params[:deleted][:items]
    deleted_items.each do |id|
      Item.find(id).destroy if (eval "@#{invoice}.items.where(:id => id).exists?")
    end

    respond_to do |format|
      if (eval "@#{invoice}.update_attributes(invoice_params)")
        format.html { redirect_to((eval "@#{invoice}"), :notice => "#{invoice.to_s.humanize.capitalize} actualizada correctamente.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => (eval "@#{invoice}.errors"), :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.xml
  def destroy
    @invoice = invoice.to_s.classify.constantize.find(params[:id])
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to((eval "#{invoice.to_s.pluralize}_url")) }
      format.xml  { head :ok }
    end
  end

  private

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
