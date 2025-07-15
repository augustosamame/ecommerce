# Database Cleanup Tasks

This document explains how to use and schedule the database cleanup tasks to maintain optimal database size and performance.

## Available Tasks

### 1. Clean Old Carts
Removes carts older than 3 months:
```
bundle exec rake ecommerce:clean_old_carts
```

### 2. Clean Old Wishlists
Removes wishlists older than 6 months:
```
bundle exec rake ecommerce:clean_old_wishlists
```

### 3. Combined Cleanup
Runs both cart and wishlist cleanup tasks:
```
bundle exec rake ecommerce:clean_database
```

### 4. Vacuum Wishlist Table
Performs maintenance on the wishlist table to reclaim space:
```
bundle exec rake ecommerce:vacuum_wishlist
```

## Setting Up Scheduled Cleanup

There are two ways to set up scheduled cleanup:

### Option 1: Using Rails Runner (Recommended)

This matches your current cronjob setup:

```bash
# Daily cleanup at 3:00 AM - cleans both carts and wishlists
0 3 * * * /bin/bash -l -c 'cd /home/deploy/rails_app/releases/CURRENT_RELEASE && bundle exec bin/rails runner -e production "Ecommerce::Cart.clean_old_carts; Ecommerce::Wishlist.clean_old_wishlists"'

# Weekly vacuum of wishlist table on Sunday at 4:00 AM
0 4 * * 0 /bin/bash -l -c 'cd /home/deploy/rails_app/releases/CURRENT_RELEASE && bundle exec bin/rails runner -e production "ActiveRecord::Base.connection.execute(\'VACUUM FULL ecommerce_wishlists;\')"'
```

### Option 2: Using Rake Tasks

```bash
# Daily cleanup at 3:00 AM
0 3 * * * /bin/bash -l -c 'cd /home/deploy/rails_app/releases/CURRENT_RELEASE && bundle exec rake ecommerce:clean_database RAILS_ENV=production'

# Weekly vacuum of wishlist table on Sunday at 4:00 AM
0 4 * * 0 /bin/bash -l -c 'cd /home/deploy/rails_app/releases/CURRENT_RELEASE && bundle exec rake ecommerce:vacuum_wishlist RAILS_ENV=production'
```

Replace `CURRENT_RELEASE` with your actual release path or use a symlink to the current release.

## Monitoring

After setting up these cleanup tasks, monitor your database size to ensure it's decreasing as expected. You can check table sizes with:

```sql
SELECT
  table_name,
  pg_size_pretty(pg_total_relation_size(quote_ident(table_name))) AS total_size,
  pg_size_pretty(pg_relation_size(quote_ident(table_name))) AS data_size,
  pg_size_pretty(pg_total_relation_size(quote_ident(table_name)) - pg_relation_size(quote_ident(table_name))) AS index_size,
  pg_total_relation_size(quote_ident(table_name)) / 1024 / 1024 AS size_mb
FROM
  (SELECT table_schema || '.' || table_name AS table_name
   FROM information_schema.tables
   WHERE table_schema='public'
   ORDER BY pg_total_relation_size(table_schema || '.' || table_name) DESC) AS tables;
```

## Troubleshooting

If you encounter any issues with these tasks:

1. Check the application logs for error messages
2. Ensure your database user has sufficient permissions to perform DELETE operations and VACUUM
3. For the VACUUM FULL operation, ensure you have enough disk space (it creates a new copy of the table)
