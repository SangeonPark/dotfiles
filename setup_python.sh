#!/bin/bash

# setup_python.sh - Python environment setup script
# This script handles uv installation, Python setup, and virtual environment creation

set -e  # Exit on any error

echo "🐍 Setting up Python environment..."

# Add uv to PATH for this session
export PATH="$HOME/.local/bin:$PATH"

# Install uv if not already installed
if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv Python package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"  # Refresh PATH after install
    echo "✅ uv installed successfully"
else
    echo "✅ uv already installed: $(uv --version)"
fi

# Install Python 3.12 if not already installed
echo "🔍 Checking for Python 3.12..."
if ! uv python list | grep -q "3.12"; then
    echo "📦 Installing Python 3.12..."
    uv python install 3.12
    echo "✅ Python 3.12 installed successfully"
else
    echo "✅ Python 3.12 already installed"
fi

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "🏗️  Creating virtual environment..."
    uv venv
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment and install packages
echo "📦 Installing Python packages..."
source .venv/bin/activate

if ! uv pip list | grep -q "ipykernel"; then
    echo "📦 Installing ipykernel and simple-gpu-scheduler..."
    uv pip install ipykernel simple-gpu-scheduler
    echo "✅ Python packages installed successfully"
else
    echo "✅ Python packages already installed"
fi

# Install Jupyter kernel if not already installed
echo "🔍 Checking Jupyter kernel..."
if ! jupyter kernelspec list 2>/dev/null | grep -q "venv"; then
    echo "📦 Installing Jupyter kernel..."
    python -m ipykernel install --user --name=venv
    echo "✅ Jupyter kernel 'venv' installed successfully"
else
    echo "✅ Jupyter kernel already installed"
fi

echo "🎉 Python environment setup complete!"
echo ""
echo "To activate the virtual environment manually, run:"
echo "  source .venv/bin/activate"
echo ""
echo "Available commands:"
echo "  python --version"
echo "  uv --version"
echo "  jupyter kernelspec list"