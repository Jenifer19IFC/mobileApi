from flask import Flask, request, jsonify
import json

app = Flask(__name__)

pessoas = []
cachorros = []

def carregar_dados(): # JSON
    global pessoas, cachorros
    try:
        with open("dados.json", "r") as arquivo:
            dados = json.load(arquivo)
            pessoas = dados.get("pessoas", [])
            cachorros = dados.get("cachorros", [])
    except FileNotFoundError:
        pessoas = []
        cachorros = []

def salvar_dados(): # JSON
    with open("dados.json", "w") as arquivo:
        json.dump({"pessoas": pessoas, "cachorros": cachorros},
                  arquivo, indent=4)

# Lista todas as pessoas 
@app.route('/pessoas', methods=['GET'])
def listar_pessoas():
    return jsonify(pessoas), 200

# Vincula o cachorro na pessoa
@app.route('/vincular', methods=['POST'])
def vincular_cachorro_pessoa():
    data = request.get_json()
    id_pessoa = data.get("id_pessoa")
    id_cachorro = data.get("id_cachorro")
    raca = data.get("raca")

    print(f"id_pessoa: {id_pessoa}, id_cachorro: {id_cachorro}")

    pessoa = next(
        (p for p in pessoas if p["id"] == id_pessoa and p["cachorro_id"] is None), None)
    if not pessoa:
        return jsonify({"erro": "Pessoa não encontrada ou já vinculada a um cachorro"}), 400

    cachorro = next(
        (c for c in cachorros if c["id"] == id_cachorro and c["pessoa_id"] is None), None)
    if cachorro:
        return jsonify({"erro": "Cachorro já vinculado a uma pessoa"}), 400

    pessoa["cachorro_id"] = id_cachorro
    cachorro = {
        "id": id_cachorro,
        "nome": "Max",
        "raca": raca,
        "pessoa_id": id_pessoa
    }
    cachorros.append(cachorro)
    salvar_dados()

    return jsonify({
        "mensagem": f'Cachorro {cachorro["nome"]} vinculado com sucesso à pessoa {pessoa["nome"]}!',
        "pessoa": pessoa,
        "cachorro": cachorro
    }), 200


@app.route('/listar_vinculos', methods=['GET'])
def listar_vinculos():
    vinculos = [
        {
            "pessoa": p["nome"],
            "cachorro": next((c["raca"] for c in cachorros if c["id"] == p["cachorro_id"]), "Nenhum")
        }
        for p in pessoas
    ]
    return jsonify(vinculos), 200

if __name__ == "__main__":
    carregar_dados()
    app.run(debug=True, port=5000)
