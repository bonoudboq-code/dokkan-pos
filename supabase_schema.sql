-- ========================================================
-- مخطط قاعدة بيانات نظام "دكان" (Dokkan POS) لـ Supabase
-- قم بتشغيل هذا السكربت في SQL Editor الخاص بـ Supabase
-- ========================================================

-- 1. جدول التصنيفات والأقسام (Categories)
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. جدول الوحدات (Units)
CREATE TABLE IF NOT EXISTS public.units (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- مثل: قطعة، كرتونة، كيلو
    short_name VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. جدول الموردين (Suppliers)
CREATE TABLE IF NOT EXISTS public.suppliers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(255),
    address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. جدول العملاء (Customers)
CREATE TABLE IF NOT EXISTS public.customers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    email VARCHAR(255),
    address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. جدول المنتجات والمخزون (Products)
CREATE TABLE IF NOT EXISTS public.products (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    sku VARCHAR(100) UNIQUE,
    barcode VARCHAR(100),
    category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,
    unit_id UUID REFERENCES public.units(id) ON DELETE SET NULL,
    cost_price DECIMAL(12, 2) DEFAULT 0.00 NOT NULL,
    selling_price DECIMAL(12, 2) DEFAULT 0.00 NOT NULL,
    quantity INTEGER DEFAULT 0 NOT NULL,
    min_quantity INTEGER DEFAULT 5 NOT NULL,
    image_url TEXT,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. جدول فواتير المبيعات (Sales Invoices)
CREATE TABLE IF NOT EXISTS public.sales_invoices (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    invoice_number VARCHAR(100) UNIQUE NOT NULL,
    customer_id UUID REFERENCES public.customers(id) ON DELETE SET NULL,
    total_amount DECIMAL(12, 2) DEFAULT 0.00 NOT NULL,
    tax_amount DECIMAL(12, 2) DEFAULT 0.00 NOT NULL,
    discount_amount DECIMAL(12, 2) DEFAULT 0.00 NOT NULL,
    grand_total DECIMAL(12, 2) DEFAULT 0.00 NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'cash' NOT NULL, -- كاش، بطاقة، تحويل
    payment_status VARCHAR(50) DEFAULT 'paid' NOT NULL, -- مدفوع، معلق، جزئي
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. جدول تفاصيل عناصر الفاتورة (Sales Invoice Items)
CREATE TABLE IF NOT EXISTS public.sales_invoice_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    invoice_id UUID REFERENCES public.sales_invoices(id) ON DELETE CASCADE NOT NULL,
    product_id UUID REFERENCES public.products(id) ON DELETE SET NULL,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 8. تفعيل سياسات الأمان RLS والسماح بالقراءة والكتابة المبدئية
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.units ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales_invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sales_invoice_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read categories" ON public.categories FOR SELECT USING (true);
CREATE POLICY "Allow public insert categories" ON public.categories FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update categories" ON public.categories FOR UPDATE USING (true);

CREATE POLICY "Allow public read products" ON public.products FOR SELECT USING (true);
CREATE POLICY "Allow public insert products" ON public.products FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update products" ON public.products FOR UPDATE USING (true);
CREATE POLICY "Allow public delete products" ON public.products FOR DELETE USING (true);

CREATE POLICY "Allow public read sales_invoices" ON public.sales_invoices FOR SELECT USING (true);
CREATE POLICY "Allow public insert sales_invoices" ON public.sales_invoices FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public read sales_invoice_items" ON public.sales_invoice_items FOR SELECT USING (true);
CREATE POLICY "Allow public insert sales_invoice_items" ON public.sales_invoice_items FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public read customers" ON public.customers FOR SELECT USING (true);
CREATE POLICY "Allow public insert customers" ON public.customers FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public read suppliers" ON public.suppliers FOR SELECT USING (true);
CREATE POLICY "Allow public insert suppliers" ON public.suppliers FOR INSERT WITH CHECK (true);

-- بيانات تجريبية أولية لنظام دكان
INSERT INTO public.categories (name, code, description) VALUES
('إلكترونيات وهواتف', 'ELEC', 'أجهزة إلكترونية وهواتف ومستلزماتها'),
('مواد غذائية', 'FOOD', 'منتجات وبقالة ومواد غذائية')
ON CONFLICT DO NOTHING;
