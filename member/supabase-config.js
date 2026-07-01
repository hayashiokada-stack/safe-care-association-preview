import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm";

export const SUPABASE_URL = "https://pedxdvjgpxgqjwmwomby.supabase.co";
export const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBlZHhkdmpncHhncWp3bXdvbWJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk4MTc4NzMsImV4cCI6MjA5NTM5Mzg3M30.peK7eHmZgQZ67LdkFVGU1T7QCBMIhjbUQjjOjgy9Yuk";

export function getSupabaseClient(){
  if(
    !SUPABASE_URL ||
    !SUPABASE_ANON_KEY ||
    SUPABASE_URL.includes("YOUR-PROJECT-REF") ||
    SUPABASE_ANON_KEY.includes("YOUR_SUPABASE_ANON_KEY")
  ){
    throw new Error("supabase-not-configured");
  }
  return createClient(SUPABASE_URL,SUPABASE_ANON_KEY,{
    auth:{
      flowType:"pkce",
      persistSession:true,
      autoRefreshToken:true,
      detectSessionInUrl:true
    }
  });
}
