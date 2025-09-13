"""Remove unnecessary models

Revision ID: 001_remove_unnecessary_models
Revises: 0001_remove_unnecessary_models
Create Date: 2025-01-27 10:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = '001_remove_unnecessary_models'
down_revision = '0001_remove_unnecessary_models'
branch_labels = None
depends_on = None


def upgrade():
    """
    Remove unnecessary tables and add sync fields to shops table.
    
    This migration removes the following tables that are no longer needed
    as per the updated business requirements:
    - orders
    - order_lines  
    - payments
    - outstandings
    - products
    
    It also adds sync fields to the shops table for client data synchronization.
    """
    
    # Drop foreign key constraints first
    op.drop_constraint('fk_order_lines_order_id_orders', 'order_lines', type_='foreignkey')
    op.drop_constraint('fk_order_lines_product_id_products', 'order_lines', type_='foreignkey')
    op.drop_constraint('fk_orders_shop_id_shops', 'orders', type_='foreignkey')
    op.drop_constraint('fk_payments_shop_id_shops', 'payments', type_='foreignkey')
    op.drop_constraint('fk_outstandings_shop_id_shops', 'outstandings', type_='foreignkey')
    
    # Drop the unnecessary tables
    op.drop_table('order_lines')
    op.drop_table('orders')
    op.drop_table('payments')
    op.drop_table('outstandings')
    op.drop_table('products')
    
    # Add sync fields to shops table
    op.add_column('shops', sa.Column('last_sync_date', sa.DateTime(), nullable=True))
    op.add_column('shops', sa.Column('sync_status', sa.String(20), nullable=True, default='pending'))
    op.add_column('shops', sa.Column('sync_error', sa.String(500), nullable=True))
    
    # Create index for sync status
    op.create_index('idx_shops_sync_status', 'shops', ['sync_status'])


def downgrade():
    """
    Recreate the removed tables and remove sync fields from shops table.
    
    This is a rollback migration that recreates the removed tables
    and removes the sync fields from the shops table.
    """
    
    # Remove sync fields from shops table
    op.drop_index('idx_shops_sync_status', table_name='shops')
    op.drop_column('shops', 'sync_error')
    op.drop_column('shops', 'sync_status')
    op.drop_column('shops', 'last_sync_date')
    
    # Recreate products table
    op.create_table('products',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('sku', sa.String(100), nullable=False),
        sa.Column('name', sa.String(255), nullable=False),
        sa.Column('category', sa.String(100), nullable=True),
        sa.Column('mrp', sa.Numeric(10, 2), nullable=True),
        sa.Column('tenant_id', sa.String(50), nullable=False),
        sa.Column('last_synced', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=True),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('updated_by', sa.Integer(), nullable=True),
        sa.PrimaryKeyConstraint('id'),
        sa.Index('idx_tenant_sku', 'tenant_id', 'sku'),
        sa.Index('idx_category', 'category')
    )
    
    # Recreate orders table
    op.create_table('orders',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('order_id', sa.String(100), nullable=False),
        sa.Column('shop_id', sa.String(100), nullable=False),
        sa.Column('order_date', sa.Date(), nullable=False),
        sa.Column('status', sa.Enum('pending', 'confirmed', 'delivered', 'cancelled', name='orderstatus'), nullable=False),
        sa.Column('total_amount', sa.Numeric(12, 2), nullable=True),
        sa.Column('tenant_id', sa.String(50), nullable=False),
        sa.Column('last_synced', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=True),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('updated_by', sa.Integer(), nullable=True),
        sa.PrimaryKeyConstraint('id'),
        sa.Index('idx_tenant_shop', 'tenant_id', 'shop_id'),
        sa.Index('idx_order_date', 'order_date'),
        sa.Index('idx_status', 'status')
    )
    
    # Recreate order_lines table
    op.create_table('order_lines',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('order_id', sa.Integer(), nullable=False),
        sa.Column('sku', sa.String(100), nullable=False),
        sa.Column('quantity', sa.Integer(), nullable=False),
        sa.Column('rate', sa.Numeric(10, 2), nullable=False),
        sa.Column('amount', sa.Numeric(12, 2), nullable=False),
        sa.Column('tenant_id', sa.String(50), nullable=False),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('updated_by', sa.Integer(), nullable=True),
        sa.PrimaryKeyConstraint('id'),
        sa.Index('idx_order_sku', 'order_id', 'sku'),
        sa.ForeignKeyConstraint(['order_id'], ['orders.id'], name='fk_order_lines_order_id_orders'),
        sa.ForeignKeyConstraint(['sku'], ['products.sku'], name='fk_order_lines_product_id_products')
    )
    
    # Recreate payments table
    op.create_table('payments',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('payment_id', sa.String(100), nullable=False),
        sa.Column('shop_id', sa.String(100), nullable=False),
        sa.Column('amount', sa.Numeric(12, 2), nullable=False),
        sa.Column('payment_date', sa.Date(), nullable=False),
        sa.Column('payment_method', sa.String(50), nullable=True),
        sa.Column('tenant_id', sa.String(50), nullable=False),
        sa.Column('last_synced', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=True),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('updated_by', sa.Integer(), nullable=True),
        sa.PrimaryKeyConstraint('id'),
        sa.Index('idx_tenant_shop', 'tenant_id', 'shop_id'),
        sa.Index('idx_payment_date', 'payment_date')
    )
    
    # Recreate outstandings table
    op.create_table('outstandings',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('shop_id', sa.String(100), nullable=False),
        sa.Column('amount_due', sa.Numeric(12, 2), nullable=False),
        sa.Column('as_of_date', sa.Date(), nullable=False),
        sa.Column('days_overdue', sa.Integer(), nullable=False),
        sa.Column('tenant_id', sa.String(50), nullable=False),
        sa.Column('last_synced', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=True),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('updated_at', sa.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP'), nullable=False),
        sa.Column('created_by', sa.Integer(), nullable=True),
        sa.Column('updated_by', sa.Integer(), nullable=True),
        sa.PrimaryKeyConstraint('id'),
        sa.Index('idx_tenant_shop', 'tenant_id', 'shop_id'),
        sa.Index('idx_days_overdue', 'days_overdue')
    )
    
    # Recreate foreign key constraints
    op.create_foreign_key('fk_orders_shop_id_shops', 'orders', 'shops', ['shop_id'], ['id'])
    op.create_foreign_key('fk_payments_shop_id_shops', 'payments', 'shops', ['shop_id'], ['id'])
    op.create_foreign_key('fk_outstandings_shop_id_shops', 'outstandings', 'shops', ['shop_id'], ['id'])
