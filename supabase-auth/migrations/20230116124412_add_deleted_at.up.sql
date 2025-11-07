-- adds deleted_at column to auth.users 

alter table users
add column if not exists deleted_at timestamptz null;
