-- Add color column to departments table
ALTER TABLE departments ADD COLUMN IF NOT EXISTS color VARCHAR(7) DEFAULT '#3b82f6';

-- Update existing departments with default colors if they don't have one
UPDATE departments SET color = '#3b82f6' WHERE color IS NULL;

-- Show confirmation
SELECT '✅ Color column added to departments table successfully!' as result;

