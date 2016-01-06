require 'test_helper'

class FacturasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:facturas)
    assert_template :index
  end

  test "should get edit page" do
    get :edit, {id: facturas(:factura_con_items).id}
    assert_response :success
    assert_not_nil assigns(:factura)
    assert_template :edit
    assert_equal assigns(:factura).attributes, facturas(:factura_con_items).attributes
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
    factura_attributes = factura_original.attributes.merge({
      number: factura_original.number + 100, 
      cliente_attributes: factura_original.cliente.attributes.except("email").merge({nombre: "NombreActualizado"}), 
      items_attributes: {"0" => factura_original.items[1].attributes.merge({cantidad:  "100"})}})

    # when
    patch :update, id: factura_original.id, factura: factura_attributes, deleted: {items: "[\"#{factura_original.items[0].id}\"]"}

    # then
    assert_redirected_to factura_path(factura_original)
    assert_equal assigns(:factura).number, factura_original.number + 100
    assert_equal assigns(:factura).cliente.nombre, "NombreActualizado"
    assert_equal assigns(:factura).cliente.id, factura_original.cliente.id
    assert_equal assigns(:factura).items.count, 1
    assert_equal factura_original.items[1].id, assigns(:factura).items[0].id
    assert_equal 100, assigns(:factura).items[0].cantidad
    assert_equal 'Factura actualizada correctamente.', flash[:notice]

  end

  test "should should destroy factura" do
      
    assert_difference('Factura.count', -1) do
      assert_difference('Item.count', -2) do
        delete :destroy, id: facturas(:factura_con_items)
      end
    end

    assert_redirected_to facturas_path
  end
end
