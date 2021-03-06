unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IniFiles, Contnrs, spdNFCeDataSets, spdNFCe,
  ShellAPI, spdNFCeType,
  ComCtrls;

type
  TfrmPrincipal = class(TForm)
    pgcNFCe: TPageControl;
    tbsNfe: TTabSheet;
    GroupBox2: TGroupBox;
    GroupBox4: TGroupBox;
    TabImpressao: TTabSheet;
    gbImpressao: TGroupBox;
    TabDemaisMetodos: TTabSheet;
    GroupBox5: TGroupBox;
    edtUF: TLabeledEdit;
    edtCNPJ: TLabeledEdit;
    edtId: TLabeledEdit;
    edtRecibo: TLabeledEdit;
    edtProtocolo: TLabeledEdit;
    cbCertificado: TComboBox;
    Label1: TLabel;
    btnExportar: TButton;
    btnVisualizar: TButton;
    btnEditar: TButton;
    btnImprimir: TButton;
    ButtonEmail: TButton;
    btnXmlDestinatario: TButton;
    ButtonInutilizar: TButton;
    btnCancelar: TButton;
    pcMensagens: TPageControl;
    tsXML: TTabSheet;
    mmXml: TMemo;
    tsXMLFormatado: TTabSheet;
    mmConsulta: TMemo;
    spdNFCeDataSets: TspdNFCeDataSets;
    dlgTx2: TOpenDialog;
    spdNFCe: TspdNFCe;
    dlgXml: TOpenDialog;
    Label3: TLabel;
    edCnpjSh: TEdit;
    Label4: TLabel;
    edTokenSh: TEdit;
    btnDS4: TButton;
    btnStatus: TButton;
    btnLoadConfig: TButton;
    btnIni: TButton;
    btnConsultarRec: TButton;
    btnEnviarSincrono: TButton;
    btnAssinar: TButton;
    btnTx2400: TButton;
    btnConsultarNFCe: TButton;
    btEnviarAssincrono: TButton;
    btEnviarNfceCancelada: TButton;
    btImprimirNfceCancelada: TButton;
    procedure FormCreate(Sender: TObject);
    procedure cbCertificadoChange(Sender: TObject);
    procedure btnIniClick(Sender: TObject);
    procedure btnLoadConfigClick(Sender: TObject);
    procedure btnStatusClick(Sender: TObject);
    procedure btnAssinarClick(Sender: TObject);
    procedure btnConsultarRecClick(Sender: TObject);
    procedure btnConsultarNFCeClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnEnviarSincronoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure ButtonGerarXMLDestClick(Sender: TObject);
    procedure ButtonInutilizarClick(Sender: TObject);
    procedure ButtonEmailClick(Sender: TObject);
    procedure btEnviarAssincronoClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnDS4Click(Sender: TObject);
    procedure btnTx2400Click(Sender: TObject);
    procedure btnSalvarConfigClick(Sender: TObject);
    procedure btnXmlDestinatarioClick(Sender: TObject);
    procedure btEnviarNfceCanceladaClick(Sender: TObject);
    procedure btImprimirNfceCanceladaClick(Sender: TObject);
   // procedure pgcNFeChange(Sender: TObject);  //88
   // procedure pgcNFeChange(Sender: TObject); //88
  private
    _NumeroLote : String;
    _Dir: String;
    serie : String;
    { Private declarations }
    function obterNroResultado(const aXML: String; aTag : string; aEndTag : string): string;
    function LoadXmlDestinatario(aChaveNFe: String): WideString;
  public
    { Public declarations }
    procedure ExibirConfiguracoes;
  end;

var
  frmPrincipal: TfrmPrincipal;
  _Ini: TIniFile;

implementation

uses StrUtils;

{$R *.dfm}

procedure TfrmPrincipal.ExibirConfiguracoes;
begin
  _Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'nfceconfig.ini');

  spdNFCe.ListarCertificados(cbCertificado.Items);
  edtUF.Text := spdNFCe.UF;
  edtCNPJ.Text := spdNFCe.CNPJ;
  edCnpjSh.Text       := _Ini.ReadString('NFCE', 'cnpjSh','');
  edTokenSh.Text       := _Ini.ReadString('NFCE', 'tokenSh','');

  if((edCnpjSh.Text <>'')AND(edTokenSh.Text <>''))then
  begin
  spdNFCe.ConfigurarSoftwareHouse(edCnpjSh.Text,edTokenSh.Text);
  end
  else
  ShowMessage('Voc� deve configurar a o CNPJ e o Token da SoftwareHouse no arquivo config.ini');
end;

function TfrmPrincipal.LoadXmlDestinatario(aChaveNFe: String): WideString;
var
  _file : TStringList;
  _fileName : string;
begin
  _file := TStringList.Create;
  try
    _fileName := ExtractFilePath(ParamStr(0)) + 'XmlDestinatario\' + edtId.Text + '-nfce.xml';
    if not FileExists(_fileName) then
      raise Exception.CreateFmt('Nao foi possivel encontrar o arquivo XML %s .Verifique se NFe esta autorizada.',[_fileName]);

    _file.LoadFromFile(_fileName);
    Result := _file.Text;
  finally
    _file.Free;
  end;
end;

function TfrmPrincipal.obterNroResultado(const aXML: String; aTag,
  aEndTag: string): string;
var
  _Posini, _Posfim  : integer;
Begin
  Result := '';
  _Posini:= Pos(aTag,aXML);
  _Posfim:= Pos(aEndTag,aXML);
  if  ( _Posini > 0 ) then
    begin
      inc(_PosIni, Length(aTag));
      Result:=Copy(aXML,_Posini+1,(_PosFim-_PosIni)-1);
    end;
end;

procedure TfrmPrincipal.cbCertificadoChange(Sender: TObject);

begin
  _Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'nfceconfig.ini');
  _Ini.WriteString('NFCE','NomeCertificado',cbCertificado.Text);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  frmPrincipal.Caption := 'Tecnospeed NFCe - ' + spdNFCe.Versao;
  cbCertificado.ItemIndex :=0;
  spdNFCe.DanfceSettings.ExibirDetalhamento := true;
end;

procedure TfrmPrincipal.btnAssinarClick(Sender: TObject);
begin
  mmXml.Text := spdNFCe.AssinarNota(mmXml.Text);
  pcMensagens.ActivePage := tsXML;
end;

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
 var
  justificativa : String;
  dataEmissao   : String;
  dataEmissao19 : String;
begin
  InputQuery('Justificativa','Insira uma justificativa (min 15 caracteres): ',justificativa);//solicita a justificativa

  dataEmissao   := spdNFCeDataSets.Campo('dhEmi_B09').AsString;
  dataEmissao19 := Copy(dataEmissao,0,19);//      Substring(0,19);//retira -03:00 q ficou duplicado

  if (spdNFCeDataSets.Campo('dhEmi_B09').AsString <>'') then
  mmConsulta.Text := spdNFCe.CancelarNF(edtId.Text,edtProtocolo.Text,justificativa,dataEmissao19,1,'',_NumeroLote);//cancela a NFCe
end;

procedure TfrmPrincipal.btnConsultarNFCeClick(Sender: TObject);
begin
  mmConsulta.Text := spdNFCe.ConsultarNF(edtId.Text);
  edtProtocolo.Text := obterNroResultado(mmXml.Text, '<nProt','</nProt');
  pcMensagens.ActivePage := tsXMLFormatado;
end;

procedure TfrmPrincipal.btnConsultarRecClick(Sender: TObject);
begin
  mmXml.Text := spdNFCe.ConsultarRecibo(edtRecibo.Text);
  edtProtocolo.Text := obterNroResultado(mmConsulta.Text, '<nProt','</nProt');
  pcMensagens.ActivePage := tsXMLFormatado;
end;

procedure TfrmPrincipal.btnDS4Click(Sender: TObject);

  procedure DadosDoNFCe400(aDs : TspdNFCeDataSets; serie : String);
  var
    _NRNota : String;
  begin
    aDs.campo('versao_A02').Value   := '4.00'; //Vers�o do leiaute
    aDs.Campo('cUF_B02').Value      := '41'; //C�digo da UF do emitente do Documento Fiscal
    aDs.Campo('cNF_B03').Value      := '00005678'; //C�digo Num�rico que comp�e a Chave de Acesso
    aDs.Campo('natOp_B04').Value    := 'VENDA MERC.ADQ.REC.TERC'; //Descri��o da Natureza da Opera��o
    //remobido na 4.00 indPag_B05
    aDs.Campo('mod_B06').Value      := '65'; //Modelo do Documento Fiscal
    aDs.Campo('serie_B07').Value    := serie; //S�rie do Documento Fiscal

    Randomize;
    _NRNota                         := IntToStr(Random(100000));
    aDs.Campo('nNF_B08').Value      := _NRNota; //N�mero do Documento Fiscal
    aDs.Campo('dhEmi_B09').Value    := FormatDateTime('YYYY-mm-dd"T"HH:mm:ss',now) + '-03:00'; //Data e Hora de emiss�o do Documento Fiscal
    aDs.Campo('tpNF_B11').Value     := '1'; //Tipo de Opera��o: 0-entrada / 1-sa�da.
	  aDs.Campo('idDest_B11a').Value  := '1'; //Identificador de local de destino da opera��o: 1- Opera��o interna; 2- Opera��o interestadual; 3- Opera��o com exterior.
    aDs.Campo('cMunFG_B12').Value   := '4115200'; //C�digo do Munic�pio de Ocorr�ncia do Fato Gerador (Codigo Maringa)
    aDs.Campo('tpImp_B21').Value    := '4';
    aDs.Campo('tpEmis_B22').Value   := '1';
//  ads.Campo('xJust_B29').Value := 'Justificativa de entrada em contingencia';
//  ads.Campo('dhCont_B28').Value := FormatDateTime('YYYY-mm-dd"T"HH:mm:ss',now) + '-02:00';

	{1- Emiss�o normal (n�o em conting�ncia); 2- Conting�ncia FS-IA, com impress�o do DANFE em formul�rio de seguran�a; 3- Conting�ncia SCAN (Sistema de
	Conting�ncia do Ambiente Nacional); 4- Conting�ncia DPEC (Declara��o Pr�via da Emiss�o em Conting�ncia); 5- Conting�ncia FS-DA, com impress�o
	do DANFE em formul�rio de seguran�a; 6- Conting�ncia SVC-AN (SEFAZ Virtual de Conting�ncia do AN); 7- Conting�ncia SVC-RS (SEFAZ Virtual
	de Conting�ncia do RS); 9- Conting�ncia off-line da NFC-e (as demais op��es de conting�ncia s�o v�lidas tamb�m para a NFC-e); Nota: As op��es de
	conting�ncia 3, 4, 6 e 7 (SCAN, DPEC e SVC) n�o est�o dispon�veis no momento atual.}
    aDs.Campo('cDV_B23').Value      := ''; //D�gito Verificador da Chave de Acesso
    if (spdNFCe.Ambiente = akProducao) then
      ads.Campo('tpAmb_B24').value := '1'
    else
      aDs.Campo('tpAmb_B24').Value    := '2'; //Identifica��o do Ambiente: 1-Produ��o/ 2-Homologa��o

    aDs.Campo('finNFe_B25').Value   := '1'; //Finalidade de emiss�o da NF-e: 1- NF-e normal/ 2-NF-e complementar / 3 � NF-e de ajuste.
	  aDs.Campo('indFinal_B25a').Value   := '1'; //Indica opera��o com Consumidor final: 0- N�o; 1- Consumidor final;
	  aDs.Campo('indPres_B25b').Value   := '1';
	{Indicador de presen�a do comprador no estabelecimento comercial no momento da opera��o:
	0- N�o se aplica (por exemplo, Nota Fiscal complementar ou de ajuste); 1- Opera��o presencial; 2- Opera��o n�o presencial, pela Internet;
	3- Opera��o n�o presencial, Teleatendimento; 9- Opera��o n�o presencial, outros.}
    aDs.Campo('procEmi_B26').Value  := '0';
	{Processo de emiss�o: Identificador do processo de emiss�o da NF-e: 0 - emiss�o de NF-e com aplicativo do contribuinte; 1 - emiss�o de NF-e avulsa pelo
	Fisco; 2 - emiss�o de NF-e avulsa, pelo contribuinte com seu certificado digital, atrav�s do site do Fisco; 3- emiss�o NF-e pelo contribuinte com
	aplicativo fornecido pelo Fisco.}
    aDs.Campo('verProc_B27').Value  := '000'; //Vers�o do Processo de emiss�o da NF-e
  end;

  procedure DadosDoEmitente(aDs : TspdNFCeDataSets);
  begin
    aDs.Campo('CNPJ_C02').Value     := edtCNPJ.Text; //CNPJ do emitente
    aDs.Campo('xNome_C03').Value    := 'TECNOSPEED TECNOLOGIA DE INFORMACAO LTDA'; //Raz�o Social ou Nome do emitente
    aDs.Campo('xFant_C04').Value    := 'TECNOSPEED TECNOLOGIA DE INFORMACAO LTDA'; //Nome fantasia
    aDs.Campo('xLgr_C06').Value     := 'AV DUQUE DE CAXIAS'; //Logradouro
    aDs.Campo('nro_C07').Value      := '882'; //N�mero
    aDs.Campo('xBairro_C09').Value  := 'CENTRO'; //Complemento
    aDs.Campo('cMun_C10').Value     := '4115200'; //C�digo do munic�pio Maring�
    //aDs.Campo('cMun_C10').Value     := '5103403'; //C�digo do munic�pio Cuiaa
    aDs.Campo('xMun_C11').Value     := 'MARINGA'; //Nome do munic�pio
    aDs.Campo('UF_C12').Value       := edtUF.Text; //Sigla da UF
    aDs.Campo('CEP_C13').Value      := '87020025'; //C�digo do CEP
    aDs.Campo('cPais_C14').Value    := '1058'; //C�digo do Pa�s
    aDs.Campo('xPais_C15').Value    := 'BRASIL'; //Nome do Pa�s
    aDs.Campo('fone_C16').Value     := '4430379500'; //Telefone
    aDs.Campo('IE_C17').Value       := '9044016688'; //Inscri��o Estadual
    aDs.Campo('CRT_C21').Value      := '3'; //C�digo de Regime Tribut�rio: 1 � Simples Nacional; 2 � Simples Nacional � excesso de sublimite de receita bruta; 3 � Regime Normal.
  end;

  procedure DadosDoDestinatario(aDs : TspdNFCeDataSets);
  begin
    //aDs.Campo('CNPJ_E02').Value     := ''; //CNPJ do destinat�rio
    ads.Campo('CPF_E03').Value      := '84752264188'; //CPF do destinat�rio
    aDs.Campo('xNome_E04').Value    := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'; //Raz�o Social ou nome do destinat�rio
    {
    aDs.Campo('xLgr_E06').Value     := 'RUA DO CENTRO'; //Logradouro
    aDs.Campo('nro_E07').Value      := '897'; //N�mero
    ads.Campo('xCpl_E08').Value     := 'TESTE'; //Complemento
    aDs.Campo('xBairro_E09').Value  := 'CENTRO'; //Bairro
    aDs.Campo('cMun_E10').Value     := '4115200'; //C�digo do munic�pio
    aDs.Campo('xMun_E11').Value     := 'MARINGA'; //Nome do munic�pio
    aDs.Campo('UF_E12').Value       := 'PR'; //Sigla da UF
    aDs.Campo('CEP_E13').Value      := '78005370'; //C�digo do CEP
    aDs.Campo('cPais_E14').Value    := '1058'; //C�digo do Pa�s
    aDs.Campo('xPais_E15').Value    := 'BRASIL'; //Nome do Pa�s
    aDs.Campo('fone_E16').Value     := '445555555'; //Telefone
    }
    ads.Campo('indIEDest_E16a').Value := '9';
  end;

  procedure DadosDoResponsavel (aDs : TspdNFCeDataSets);
  begin
    aDs.Campo('CNPJ_ZD02').Value         := '12653157000103'; // Pessoa jur�dica respon�vel pela emiss�o
    aDs.Campo('xContato_ZD04').value     := 'nomeTeste'; // Nome do respons�vel
    aDs.Campo('email_ZD05').value        := 'teste@teste.com.br'; // Email do respons�vel t�cnico
    aDs.Campo('fone_ZD06').value         := '44999999999'; // Telefone do respons�vel
    
  end;

  procedure DadosDoItem400(aDs : TspdNFCeDataSets);
  Var
   i : Integer;
  begin
    for i := 1 to 1 do
    begin
    spdNFCeDataSets.IncluirItem;
    aDs.Campo('nItem_H02').Value    := IntToStr(i); //N�mero do item
    aDs.Campo('cProd_I02').Value    := '927803'; //C�digo do produto ou servi�o
    aDs.Campo('cEAN_I03').Value     := 'SEM GTIN'; //GTIN (Global Trade Item Number) do produto, antigo c�digo EAN ou c�digo de barras
    aDs.Campo('xProd_I04').Value    := 'NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'; //Descri��o do produto ou servi�o
    ads.Campo('NCM_I05').Value      := '30043929'; //C�digo NCM com 8 d�gitos ou 2 d�gitos (g�nero)
    aDs.Campo('CFOP_I08').Value     := '5101'; //C�digo Fiscal de Opera��es e Presta��es
    aDs.Campo('uCom_I09').Value     := 'UN'; //Unidade Comercial
    aDs.Campo('qCom_I10').Value     := '1.00'; //Quantidade Comercial
    aDs.Campo('vUnCom_I10a').Value  := '1.00'; //Valor Unit�rio de Comercializa��o
    aDs.Campo('vProd_I11').Value    := '1.00'; //Valor Total Bruto dos Produtos ou Servi�os
    aDs.Campo('cEANTrib_I12').Value := 'SEM GTIN'; //GTIN (Global Trade Item Number) da unidade tribut�vel, antigo c�digo EAN ou c�digo de barras
    aDs.Campo('uTrib_I13').Value    := 'UN'; //Unidade Tribut�vel
    aDs.Campo('qTrib_I14').Value    := '1.00'; //Quantidade Tribut�vel
    aDs.Campo('vUnTrib_I14a').Value := '1.00'; //Valor Unit�rio de tributa��o
    aDs.Campo('indTot_I17b').Value  := '1'; //Indica se valor do Item (vProd) entra no valor total da NF-e (vProd)
											//0 � o valor do item (vProd) n�o comp�e o valor total da NF-e (vProd) 1 � o valor do item (vProd) comp�e o valor total da NF-e (vProd)

    aDs.Campo('vTotTrib_M02').Value := '1.00'; //Valor Total dos Tributos no Item

    aDs.Campo('orig_N11').Value     := '0'; //Origem da mercadoria
    aDs.Campo('CST_N12').Value      := '90'; //Tributa��o do ICMS

    spdNFCeDataSets.SalvarItem;
  end;
  end;

  Procedure DadosTotalizadores400(aDs : TspdNFCeDataSets);
  begin
    aDs.Campo('vBC_W03').Value := '0.00'; //Base de C�lculo do ICMS
    aDs.Campo('vICMS_W04').Value := '0.00'; //Valor Total do ICMS
    aDs.Campo('vFCP_W04h').Value := '0.00'; //Valor do fundo de combate a pobreza
    ads.Campo('vICMSDeson_W04a').value := '0.00';
    aDs.Campo('vBCST_W05').Value := '0.00'; //Base de C�lculo do ICMS ST
    aDs.Campo('vST_W06').Value := '0.00'; //Valor Total do ICMS ST
    aDs.Campo('vFCPST_W06a').Value := '0.00'; //Valor do ST do fundo de combate a pobreza
    aDs.Campo('vFCPSTRet_W06b').Value := '0.00'; //Valor do ST retido do fundo de combate a pobreza
    aDs.Campo('vProd_W07').Value := '1.00'; //Valor Total dos produtos e servi�os
    aDs.Campo('vFrete_W08').Value := '0.00'; //Valor Total do Frete
    aDs.Campo('vSeg_W09').Value := '0.00'; //Valor Total do Seguro
    aDs.Campo('vDesc_W10').Value := '0.00'; //Valor Total do Desconto
    aDs.Campo('vII_W11').Value := '0.00'; //Valor Total do II
    aDs.Campo('vIPI_W12').Value := '0.00'; //Valor Total do IPI
    aDs.Campo('vIPIDevol_W12a').Value := '0.00'; //Valor Total do IPI de devolu��o
    aDs.Campo('vPIS_W13').Value := '0.00'; //Valor do PIS
    aDs.Campo('vCOFINS_W14').Value := '0.00'; //Valor do COFINS
    aDs.Campo('vOutro_W15').Value := '0.00'; //Outras Despesas acess�rias
    aDs.Campo('vNF_W16').Value := '1.00'; //Valor Total da NF-e
    aDs.Campo('vTotTrib_W16a').Value := '1.00'; //Valor Total dos Tributos
    aDs.Campo('modFrete_X02').Value := '9'; //Modalidade do frete: 0- Por conta do emitente; 1- Por conta do destinat�rio/remetente; 2- Por conta de terceiros; 9- Sem frete.
  end;

  procedure DadosPagamento400(aDs : TspdNFCeDataSets);
  begin
    aDs.IncluirPart('YA');
    aDs.Campo('tPag_YA02').Value := '01'; //Forma de pagamento: 01- Dinheiro; 02 -Cheque; 03- Cart�o de Cr�dito; 04- Cart�o de D�bito; 05- Cr�dito Loja;
										  //10- Vale Alimenta��o; 11- Vale Refei��o; 12- Vale Presente; 13- Vale Combust�vel; 99 � Outros.
    aDs.Campo('vPag_YA03').Value := '1.00'; //Valor do Pagamento
    aDs.Campo('vTroco_YA09').Value := '0.00'; //Valor do Troco
    aDs.SalvarPart('YA');

    ads.Campo('infCpl_Z03').Value := 'VEND:LUB-REG.1                      Pre-venda: 14823|DOC.EMITIDO POR EPP OPTANTE PELO SIMPLES NACIONL PRAZO MAXIMO P/DEV.07 DIAS E C/PREVIA AUTORIZAC |';
    ads.Campo('infAdFisco_Z02').Value := 'CERT.NEGATIVA Nr.: 0012143331   Cod.autenticidade: TT9BATL2TBBAT2AL    |ICMS RECOLHIDO ANTECIPADAMENTE POR SUBST. TRIB. CFE ART. 47 E/OU 50  DO ANEXO VIII E ART. 6 DO ANEXO XIV DO RICMS-MT';
  end;

begin
    edtRecibo.clear;
    edtProtocolo.clear;
    _NumeroLote := InputBox('NF-e', 'Insira o n�mero do lote:', '1');

    serie := InputBox('NF-e', 'Insira o n�mero da S�rie:','1');
    spdNFCeDataSets.VersaoEsquema := pl_009;


    _Dir:='C:\Program Files\TecnoSpeed\NFCe\Arquivos\Templates\vm60\Conversor\NFCeDataSets.xml';
    spdNFCeDataSets.XMLDicionario := _Dir;

    spdNFCeDataSets.LoteNFCe.Clear;
    spdNFCeDataSets.ValidaRegrasNegocio := false;

    spdNFCeDataSets.Incluir;
    DadosDoNFCe400(spdNFCeDataSets ,serie);
    DadosDoEmitente(spdNFCeDataSets);
    //Grupo n�o obrigat�rio - DadosDoDestinatario(spdNFCeDataSets);
    DadosDoItem400(spdNFCeDataSets);
    DadosTotalizadores400(spdNFCeDataSets);
    DadosPagamento400(spdNFCeDataSets);
    DadosDoResponsavel(spdNFCeDataSets);//xxx

    spdNFCeDataSets.Salvar;

    pcMensagens.ActivePage := tsXML;
    mmXML.Text := spdNFCeDataSets.LoteNFCe.GetText;
    edtId.Text := Copy(spdNFCeDataSets.Campo('Id_A03').AsString,4,44);
end;

procedure TfrmPrincipal.btnEditarClick(Sender: TObject);
begin
  if (edtId.Text <> '') then
    mmXml.Text := LoadXmlDestinatario(edtId.Text);
  spdNFCe.EditarModeloDanfce('1', mmXml.Text);
end;

procedure TfrmPrincipal.btnEnviarSincronoClick(Sender: TObject);
begin
  mmConsulta.Text := spdNFCe.EnviarNFSincrono('0001',mmXml.Text,false);
  edtProtocolo.Text := obterNroResultado(mmConsulta.Text, '<nProt','</nProt');
  pcMensagens.ActivePage := tsXMLFormatado;
end;

procedure TfrmPrincipal.btnExportarClick(Sender: TObject);
begin
  if (edtId.Text <> '') then
    mmXml.Text := LoadXmlDestinatario(edtId.Text);
  spdNFCe.ExportarDanfce('1', mmXml.Text);
end;

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
begin
  if (edtId.Text <> '') then
    mmXml.Text := LoadXmlDestinatario(edtId.Text);
    spdNFCe.DanfceSettings.InfCplMaxCol := 50;
    spdNFCe.ImprimirDanfce('1', mmXml.Text);
end;

procedure TfrmPrincipal.btnIniClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',pChar('nfceconfig.ini'),'',pChar(ExtractFilePath(ParamStr(0))),SW_SHOWMAXIMIZED);
end;

procedure TfrmPrincipal.btnLoadConfigClick(Sender: TObject);
begin
    spdNFCe.LoadConfig;
    ExibirConfiguracoes;
end;

procedure TfrmPrincipal.btnSalvarConfigClick(Sender: TObject);
begin
  spdNFCe.CNPJ := edtCNPJ.Text;
  spdNFCe.UF := edtUF.Text;
  spdNFCe.SaveConfig();
end;

procedure TfrmPrincipal.btnStatusClick(Sender: TObject);
begin
  mmConsulta.Text := spdNFCe.StatusDoServico;
  pcMensagens.ActivePage := tsXMLFormatado;
end;

procedure TfrmPrincipal.btnTx2400Click(Sender: TObject);
begin
  dlgTx2.InitialDir := ExtractFilePath(ParamStr(0));
  dlgTx2.Execute;
  if dlgTx2.FileName <> '' then
    mmXml.Text := spdNFCe.ConverterLoteParaXml(dlgTx2.FileName, lkTXTDataSet, pl_009);
  pcMensagens.ActivePage := tsXML;

  edtId.Text := obterNroResultado(mmXml.Text,'Id="NF','" versao="4.00"><ide');
  //dlgTx2.Free;
end;

procedure TfrmPrincipal.btnVisualizarClick(Sender: TObject);
begin
  if (edtId.Text <> '') then
    mmXml.Text := LoadXmlDestinatario(edtId.Text);
    spdNFCe.VisualizarDanfce('1', mmXml.Text);
end;



procedure TfrmPrincipal.btnXmlDestinatarioClick(Sender: TObject);
  var
      _arq, _arq2: TStringList;
      env_sinc_lot, _sit : String;
  begin
        _arq := TStringList.Create;
      dlgXml.InitialDir := ExtractFilePath(ParamStr(0)); //Abre Dialog para localizar arquivo
      dlgXml.Filter := '.xml';
      dlgXml.Title := 'Informe o XML autorizado de envio da pasta log (env_sinc_lot)';
      dlgXml.Execute;
      if dlgXml.FileName <> '' then
      begin
         _arq.LoadFromFile(dlgXml.FileName);
         env_sinc_lot := _arq.Text; //armazena o XML autorizado de envio da pasta log
     end;

     _arq.Free;
     dlgXml.InitialDir := ExtractFilePath(ParamStr(0)); //Abre Dialog para localizar arquivo
     dlgXml.Title := 'Informe o retorno do XML autorizado enviado da pasta log (_sit.xml)';
     dlgXml.Execute;
     if dlgXml.FileName <> '' then
     begin
         _arq2 := TStringList.Create;
         _arq2.LoadFromFile(dlgXml.FileName);
         _sit := _arq2.Text; //armazena o XML do retorno do XML autorizado enviado da pasta log
     end;
     _arq2.Free;

     spdNFCe.GerarXMLEnvioDestinatario(edtId.Text, env_sinc_lot, _sit, spdNFCe.DiretorioXmlDestinatario + edtId.Text+ 'Manual-nfce.xml');//gera o arquivo destinat�rio manualmente
     ShowMessage('Arquivo destinat�rio gerado com sucesso');
  end;


procedure TfrmPrincipal.ButtonGerarXMLDestClick(Sender: TObject);
begin
  spdNFCe.GerarXMLEnvioDestinatario(edtId.Text,
    '-env-lot.xml',
    '-rec.xml',
    spdNFCe.DiretorioXmlDestinatario + edtId.Text + '-nfce.xml');
end;

procedure TfrmPrincipal.ButtonInutilizarClick(Sender: TObject);
var
  aAno, aSerie, aIni, aFim, txtJustificativa : string;
begin

  aAno             := InputBox('NFe', 'Insira o ano da faixa a ser inutilizada', FormatDateTime('YY',date()));
  aSerie           := InputBox('NFe', 'Insira a s�rie da faixa a ser inutilizada', '0');
  aIni             := InputBox('NFe', 'Insira o n�mero inicial da faixa a ser inutilizada', '1');
  aFim             := InputBox('NFe', 'Insira o n�mero final da faixa a ser inutilizada', '1');
  txtJustificativa := InputBox('NFe', 'Insira a justificativa (min. 15 caracteres)', 'Exemplo de inutilizacao da NFCe');

  mmConsulta.Text := spdNFCe.InutilizarNF('', aAno, spdNFCe.CNPJ, '65', aSerie, aIni, aFim, txtJustificativa);
end;

procedure TfrmPrincipal.ButtonEmailClick(Sender: TObject);
begin
  spdNFCe.EnviarNotaDestinatario(edtId.Text, '', '');
end;

procedure TfrmPrincipal.btEnviarAssincronoClick(Sender: TObject);
begin
  mmConsulta.Text := spdNFCe.EnviarNF('0001',mmXml.Text,false);
  edtRecibo.Text := obterNroResultado(mmXml.Text, '<nRec','</nRec');
  pcMensagens.ActivePage := tsXMLFormatado;
end;

procedure TfrmPrincipal.Button3Click(Sender: TObject);
begin
  mmXml.Text := spdNFCe.EnviarEPEC(mmXml.Text); 
end;

procedure TfrmPrincipal.Button4Click(Sender: TObject);
var
  listaXml : TStringList;
begin
  listaXml := TStringList.Create;
  listaXml.Add(mmXML.Text);
  listaXml.SaveToFile(ExtractFilePath(ParamStr(0)) + '\Pendencencias EPEC\'
    + edtId.Text + '-pendente.xml');
end;

procedure TfrmPrincipal.btEnviarNfceCanceladaClick(Sender: TObject);
begin
  spdNFCe.EnviarNotaCanceladaDestinatario(edtId.Text); //primeiro dever� ser configura o email no config.ini
  ShowMessage('Nota cancelada enviada com sucesso!');
end;

procedure TfrmPrincipal.btImprimirNfceCanceladaClick(Sender: TObject);
var
  lotesNotas : String;
begin
  lotesNotas := spdNFCe.DiretorioXmlDestinatario + '\' + edtId.Text + '-nfce.xml,' + spdNFCe.DiretorioXmlDestinatario + '\' + edtId.Text + '-caneve.xml';
  spdNFCe.ImprimirDanfce('0',lotesNotas);
end;

end.
