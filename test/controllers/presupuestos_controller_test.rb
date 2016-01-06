require 'test_helper'

class PresupuestosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:presupuestos)
    assert_template :index
  end

  test "should get edit page" do
    get :edit, {id: presupuestos(:presupuesto_con_items).id}
    assert_response :success
    assert_not_nil assigns(:presupuesto)
    assert_template :edit
    assert_equal assigns(:presupuesto).attributes, presupuestos(:presupuesto_con_items).attributes
  end

  test "should show presupuesto" do
    get :show, {id: presupuestos(:presupuesto_sin_items).id}
    assert_response :success
    assert_not_nil assigns(:presupuesto)
    assert_template :show
    assert_equal assigns(:presupuesto).attributes, presupuestos(:presupuesto_sin_items).attributes
  end

  test "should get new form" do
    get :new
    assert_response :success
    assert_not_nil assigns(:presupuesto)
    assert_nil assigns(:presupuesto).id
    assert_template :new
  end

  test "show create presupuesto without items" do
    cliente_attributes = {:nombre => "ClienteCreado", :apellidos => "ApellidosCreado", :direccion => "DireccionCreado", :ciudad => "CiudadCreado", :provincia => "ProvinciaCreado", :codigo_postal => "29999", :telefono => "11111", :nif => "222222N"}
    presupuesto_attributes = {:number => "100", :created_at => "2016-01-04", cliente_attributes: cliente_attributes}
    assert_difference('Presupuesto.count') do
      post :create, presupuesto: presupuesto_attributes
    end
    assert_redirected_to presupuesto_path(assigns(:presupuesto))

  end

  test "show create presupuesto with items" do
    cliente_attributes = {:nombre => "ClienteCreado", :apellidos => "ApellidosCreado", :direccion => "DireccionCreado", :ciudad => "CiudadCreado", :provincia => "ProvinciaCreado", :codigo_postal => "29999", :telefono => "11111", :nif => "222222N"}
    item_0 = {cantidad: "3", precio_unidad: "10", description: "item0"}
    item_1 = {cantidad: "5", precio_unidad: "5", description: "item1"}
    items_attributes = {"0" => item_0, "1" => item_1}
    presupuesto_attributes = {:number => "100", :created_at => "2016-01-04", cliente_attributes: cliente_attributes, items_attributes: items_attributes}

    assert_difference('Presupuesto.count') do
      post :create, presupuesto: presupuesto_attributes
    end

    assert_not_nil assigns(:presupuesto)
    assert_equal 2, assigns(:presupuesto).items.count, "The number of expected items in the invoice is incorrect"
    assert_redirected_to presupuesto_path(assigns(:presupuesto))
    assert_equal 'Presupuesto creada correctamente.', flash[:notice]

  end

  test "should update presupuesto removing 1 item and updating the other" do
    presupuesto_original = presupuestos(:presupuesto_con_items)
    presupuesto_attributes = presupuesto_original.attributes.merge({
      number: presupuesto_original.number + 100, 
      cliente_attributes: presupuesto_original.cliente.attributes.except("email").merge({nombre: "NombreActualizado"}), 
      items_attributes: {"0" => presupuesto_original.items[1].attributes.merge({cantidad:  "100"})}})

    # when
    patch :update, id: presupuesto_original.id, presupuesto: presupuesto_attributes, deleted: {items: "[\"#{presupuesto_original.items[0].id}\"]"}

    # then
    assert_redirected_to presupuesto_path(presupuesto_original)
    assert_equal assigns(:presupuesto).number, presupuesto_original.number + 100
    assert_equal assigns(:presupuesto).cliente.nombre, "NombreActualizado"
    assert_equal assigns(:presupuesto).cliente.id, presupuesto_original.cliente.id
    assert_equal 2, assigns(:presupuesto).items.count
    assert_equal presupuesto_original.items[1].id, assigns(:presupuesto).items[0].id
    assert_equal 100, assigns(:presupuesto).items[0].cantidad
    assert_equal 'Presupuesto actualizada correctamente.', flash[:notice]

  end

  test "should should destroy presupuesto" do
      
    assert_difference('Presupuesto.count', -1) do
      assert_difference('Item.count', -3) do
        delete :destroy, id: presupuestos(:presupuesto_con_items)
      end
    end

    assert_redirected_to presupuestos_path
  end
end
