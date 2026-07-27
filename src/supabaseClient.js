import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.REACT_APP_SUPABASE_URL || '';
const supabaseAnonKey = process.env.REACT_APP_SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseAnonKey || supabaseUrl.includes('your-supabase-project-id')) {
  console.warn(
    'تنبيه: مفاتيح Supabase غير مضبوطة بشكل صحيح. يرجى تحديث ملف .env بالقيم الصحيحة من لوحة تحكم Supabase.'
  );
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
