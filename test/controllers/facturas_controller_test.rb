require 'test_helper'

class FacturasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:facturas)
    assert_template :index
  end

  test "should show factura" do
    get :show, {id: facturas(:factura_sin_items).id}
    assert_response :success
    assert_not_nil assigns(:factura)
    assert_template :show
    assert_equal assigns(:factura).attributes, facturas(:factura_sin_items).attributes
  end

  test "should get new form" do
    get :new
    assert_response :success
    assert_not_nil assigns(:factura)
    assert_nil assigns(:factura).id
    assert_template :new
  end

  test "show create factura without items" do
    cliente_attributes = {:nombre => "ClienteCreado", :apellidos => "ApellidosCreado", :direccion => "DireccionCreado", :ciudad => "CiudadCreado", :provincia => "ProvinciaCreado", :codigo_postal => "29999", :telefono => "11111", :nif => "222222N"}
    factura_attributes = {:number => "100", :created_at => "2016-01-04", cliente_attributes: cliente_attributes}
    assert_difference('Factura.count') do
      post :create, factura: factura_attributes
    end
    assert_redirected_to factura_path(assigns(:factura))

  end

  test "show create factura with items" do
    cliente_attributes = {:nombre => "ClienteCreado", :apellidos => "ApellidosCreado", :direccion => "DireccionCreado", :ciudad => "CiudadCreado", :provincia => "ProvinciaCreado", :codigo_postal => "29999", :telefono => "11111", :nif => "222222N"}
    item_0 = {cantidad: "3", precio_unidad: "10", description: "item0"}
    item_1 = {cantidad: "5", precio_unidad: "5", description: "item1"}
    items_attributes = {"0" => item_0, "1" => item_1}
    factura_attributes = {:number => "100", :created_at => "2016-01-04", cliente_attributes: cliente_attributes, items_attributes: items_attributes}

    assert_difference('Factura.count') do
      post :create, factura: factura_attributes
    end

    assert_not_nil assigns(:factura)
    assert_equal 2, assigns(:factura).items.count, "The number of expected items in the invoice is incorrect"
    assert_redirected_to factura_path(assigns(:factura))
    assert_equal 'Factura creada correctamente.', flash[:notice]

  end

  test "should update factura removing 1 item and updating the other" do
    factura_original = facturas(:factura_con_items)
    puts factura_original.inspect
    cliente_attributes = {:nombre => "ClienteCreado", :apellidos => "ApellidosCreado", :direccion => "DireccionCreado", :ciudad => "CiudadCreado", :provincia => "ProvinciaCreado", :codigo_postal => "29999", :telefono => "11111", :nif => "222222N"}
    item_0 = {cantidad: "3", precio_unidad: "10", description: "item0"}
    item_1 = {cantidad: "5", precio_unidad: "5", description: "item1"}
    items_attributes = {"0" => item_0, "1" => item_1}
    factura_attributes = factura_original.attributes.merge({
      number: factura_original.number + 100, 
      cliente_attributes: factura_original.cliente.attributes.except("email").merge({nombre: "NombreActualizado"}), 
      items_attributes: {}})

    # when
    patch :update, id: factura_original.id, factura: factura_attributes, deleted: {items: "[]"}

    # then
    assert_redirected_to factura_path(assigns(:factura))
    assert_equal assigns(:factura).cliente.apellidos, "ApellidosCreado"
    assert_equal 'Factura actualizada correctamente.', flash[:notice]

  end
end
