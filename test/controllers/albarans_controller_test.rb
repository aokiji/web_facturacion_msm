require 'test_helper'

class AlbaransControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:albarans)
    assert_template :index
  end

  test "should get edit page" do
    get :edit, {id: albarans(:albaran_con_items).id}
    assert_response :success
    assert_not_nil assigns(:albaran)
    assert_template :edit
    assert_equal assigns(:albaran).attributes, albarans(:albaran_con_items).attributes
  end

  test "should show albaran" do
    get :show, {id: albarans(:albaran_sin_items).id}
    assert_response :success
    assert_not_nil assigns(:albaran)
    assert_template :show
    assert_equal assigns(:albaran).attributes, albarans(:albaran_sin_items).attributes
  end

  test "should show albaran in pdf format" do
    get :show, {id: albarans(:albaran_sin_items).id, format: 'pdf'}
    assert_response :success
    assert_not_nil assigns(:albaran)
    assert_template :show
    assert_equal assigns(:albaran).attributes, albarans(:albaran_sin_items).attributes
    assert_match /application\/pdf/, response.headers['Content-Type']
  end

  test "should get new form" do
    get :new
    assert_response :success
    assert_not_nil assigns(:albaran)
    assert_nil assigns(:albaran).id
    assert_template :new
  end

  test "show create albaran without items" do
    cliente_attributes = {:nombre => "ClienteCreado", :apellidos => "ApellidosCreado", :direccion => "DireccionCreado", :ciudad => "CiudadCreado", :provincia => "ProvinciaCreado", :codigo_postal => "29999", :telefono => "11111", :nif => "222222N"}
    albaran_attributes = {:number => "100", :created_at => "2016-01-04", cliente_attributes: cliente_attributes}
    assert_difference('Albaran.count') do
      post :create, albaran: albaran_attributes
    end
    assert_redirected_to albaran_path(assigns(:albaran))

  end

  test "show create albaran with items" do
    cliente_attributes = {:nombre => "ClienteCreado", :apellidos => "ApellidosCreado", :direccion => "DireccionCreado", :ciudad => "CiudadCreado", :provincia => "ProvinciaCreado", :codigo_postal => "29999", :telefono => "11111", :nif => "222222N"}
    item_0 = {cantidad: "3", precio_unidad: "10", description: "item0"}
    item_1 = {cantidad: "5", precio_unidad: "5", description: "item1"}
    items_attributes = {"0" => item_0, "1" => item_1}
    albaran_attributes = {:number => "100", :created_at => "2016-01-04", cliente_attributes: cliente_attributes, items_attributes: items_attributes}

    assert_difference('Albaran.count') do
      post :create, albaran: albaran_attributes
    end

    assert_not_nil assigns(:albaran)
    assert_equal 2, assigns(:albaran).items.count, "The number of expected items in the invoice is incorrect"
    assert_redirected_to albaran_path(assigns(:albaran))
    assert_equal 'Albaran creada correctamente.', flash[:notice]

  end

  test "should update albaran removing 1 item and updating the other" do
    albaran_original = albarans(:albaran_con_items)
    albaran_attributes = albaran_original.attributes.merge({
      number: albaran_original.number + 100, 
      cliente_attributes: albaran_original.cliente.attributes.except("email").merge({nombre: "NombreActualizado"}), 
      items_attributes: {"0" => albaran_original.items[1].attributes.merge({cantidad:  "100"})}})

    # when
    patch :update, id: albaran_original.id, albaran: albaran_attributes, deleted: {items: "[\"#{albaran_original.items[0].id}\"]"}

    # then
    assert_redirected_to albaran_path(albaran_original)
    assert_equal assigns(:albaran).number, albaran_original.number + 100
    assert_equal assigns(:albaran).cliente.nombre, "NombreActualizado"
    assert_equal assigns(:albaran).cliente.id, albaran_original.cliente.id
    assert_equal 1, assigns(:albaran).items.count
    assert_equal albaran_original.items[1].id, assigns(:albaran).items[0].id
    assert_equal 100, assigns(:albaran).items[0].cantidad
    assert_equal 'Albaran actualizada correctamente.', flash[:notice]

  end

  test "should should destroy albaran" do
      
    assert_difference('Albaran.count', -1) do
      assert_difference('Item.count', -2) do
        delete :destroy, id: albarans(:albaran_con_items)
      end
    end

    assert_redirected_to albarans_path
  end
end
