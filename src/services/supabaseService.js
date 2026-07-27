import { supabase } from '../supabaseClient';

// ==========================================
// 1. المنتجات (Products)
// ==========================================
export const getProducts = async () => {
  const { data, error } = await supabase
    .from('products')
    .select('*, categories(name), units(name)')
    .order('created_at', { ascending: false });

  if (error) {
    console.error('خطأ في جلب المنتجات من Supabase:', error.message);
    throw error;
  }
  return data;
};

export const addProduct = async (productData) => {
  const { data, error } = await supabase
    .from('products')
    .insert([productData])
    .select();

  if (error) {
    console.error('خطأ في إضافة المنتج:', error.message);
    throw error;
  }
  return data[0];
};

export const updateProduct = async (id, productData) => {
  const { data, error } = await supabase
    .from('products')
    .update(productData)
    .eq('id', id)
    .select();

  if (error) {
    console.error('خطأ في تحديث المنتج:', error.message);
    throw error;
  }
  return data[0];
};

export const deleteProduct = async (id) => {
  const { data, error } = await supabase
    .from('products')
    .delete()
    .eq('id', id);

  if (error) {
    console.error('خطأ في حذف المنتج:', error.message);
    throw error;
  }
  return data;
};

// ==========================================
// 2. التصنيفات والأقسام (Categories)
// ==========================================
export const getCategories = async () => {
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .order('name', { ascending: true });

  if (error) {
    console.error('خطأ في جلب الأقسام:', error.message);
    throw error;
  }
  return data;
};

export const addCategory = async (categoryData) => {
  const { data, error } = await supabase
    .from('categories')
    .insert([categoryData])
    .select();

  if (error) {
    console.error('خطأ في إضافة القسم:', error.message);
    throw error;
  }
  return data[0];
};

// ==========================================
// 3. العملاء (Customers)
// ==========================================
export const getCustomers = async () => {
  const { data, error } = await supabase
    .from('customers')
    .select('*')
    .order('name', { ascending: true });

  if (error) {
    console.error('خطأ في جلب العملاء:', error.message);
    throw error;
  }
  return data;
};

export const addCustomer = async (customerData) => {
  const { data, error } = await supabase
    .from('customers')
    .insert([customerData])
    .select();

  if (error) {
    console.error('خطأ في إضافة العملاء:', error.message);
    throw error;
  }
  return data[0];
};

// ==========================================
// 4. الموردين (Suppliers)
// ==========================================
export const getSuppliers = async () => {
  const { data, error } = await supabase
    .from('suppliers')
    .select('*')
    .order('name', { ascending: true });

  if (error) {
    console.error('خطأ في جلب الموردين:', error.message);
    throw error;
  }
  return data;
};

export const addSupplier = async (supplierData) => {
  const { data, error } = await supabase
    .from('suppliers')
    .insert([supplierData])
    .select();

  if (error) {
    console.error('خطأ في إضافة المورد:', error.message);
    throw error;
  }
  return data[0];
};

// ==========================================
// 5. المبيعات والفواتير (Sales & Invoices)
// ==========================================
export const getSalesInvoices = async () => {
  const { data, error } = await supabase
    .from('sales_invoices')
    .select('*, customers(name), sales_invoice_items(*, products(name))')
    .order('created_at', { ascending: false });

  if (error) {
    console.error('خطأ في جلب فواتير المبيعات:', error.message);
    throw error;
  }
  return data;
};

export const createSalesInvoice = async (invoiceData, itemsData) => {
  // 1. إنشاء الفاتورة
  const { data: invoice, error: invoiceError } = await supabase
    .from('sales_invoices')
    .insert([invoiceData])
    .select();

  if (invoiceError) {
    console.error('خطأ في إنشاء الفاتورة:', invoiceError.message);
    throw invoiceError;
  }

  const invoiceId = invoice[0].id;

  // 2. إدراج عناصر الفاتورة
  const formattedItems = itemsData.map((item) => ({
    invoice_id: invoiceId,
    product_id: item.product_id,
    quantity: item.quantity,
    unit_price: item.unit_price,
    subtotal: item.quantity * item.unit_price,
  }));

  const { error: itemsError } = await supabase
    .from('sales_invoice_items')
    .insert(formattedItems);

  if (itemsError) {
    console.error('خطأ في تفاصيل عناصر الفاتورة:', itemsError.message);
    throw itemsError;
  }

  return invoice[0];
};
