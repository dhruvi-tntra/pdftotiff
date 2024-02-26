DO $$ 
DECLARE 
    table_record record;
BEGIN
    FOR table_record IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || table_record.tablename || ' CASCADE;';
    END LOOP;
END $$;
